using System.Net;
using System.Net.Mail;
using System.Text;
using Microsoft.Extensions.Options;

namespace backend.Services.Guest;

public class SmtpEmailSender : IEmailSender
{
    private readonly EmailSettings _settings;

    public SmtpEmailSender(IOptions<EmailSettings> settings)
    {
        _settings = settings.Value;
    }

    public async Task SendContactMessageAsync(
        string senderName,
        string senderEmail,
        string? subject,
        string message,
        CancellationToken cancellationToken
    )
    {
        EnsureConfigured();

        using var mailMessage = new MailMessage
        {
            From = new MailAddress(_settings.FromEmail, _settings.FromName, Encoding.UTF8),
            Subject = $"EduNext Contact: {NormalizeSubject(subject)}",
            Body = BuildBody(senderName, senderEmail, subject, message),
            IsBodyHtml = false,
            BodyEncoding = Encoding.UTF8,
            SubjectEncoding = Encoding.UTF8
        };

        mailMessage.To.Add(new MailAddress(_settings.ContactInbox));
        mailMessage.ReplyToList.Add(new MailAddress(senderEmail, senderName, Encoding.UTF8));

        using var smtpClient = new SmtpClient(_settings.Host, _settings.Port)
        {
            EnableSsl = _settings.EnableSsl,
            Credentials = new NetworkCredential(_settings.Username, _settings.Password)
        };

        await smtpClient.SendMailAsync(mailMessage, cancellationToken);
    }

    private void EnsureConfigured()
    {
        if (
            string.IsNullOrWhiteSpace(_settings.Host) ||
            string.IsNullOrWhiteSpace(_settings.Username) ||
            string.IsNullOrWhiteSpace(_settings.Password) ||
            string.IsNullOrWhiteSpace(_settings.FromEmail) ||
            string.IsNullOrWhiteSpace(_settings.ContactInbox)
        )
        {
            throw new InvalidOperationException("Email SMTP settings are missing.");
        }
    }

    private static string NormalizeSubject(string? subject)
    {
        return string.IsNullOrWhiteSpace(subject) ? "New message" : subject.Trim();
    }

    private static string BuildBody(string senderName, string senderEmail, string? subject, string message)
    {
        var builder = new StringBuilder();
        builder.AppendLine("New contact message from EduNext website");
        builder.AppendLine();
        builder.AppendLine($"Name: {senderName}");
        builder.AppendLine($"Email: {senderEmail}");
        builder.AppendLine($"Subject: {NormalizeSubject(subject)}");
        builder.AppendLine();
        builder.AppendLine("Message:");
        builder.AppendLine(message);

        return builder.ToString();
    }
}
