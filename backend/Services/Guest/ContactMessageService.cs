using backend.Data.Generated;
using backend.DTOs.Guest;
using backend.Models;

namespace backend.Services.Guest;

public class ContactMessageService : IContactMessageService
{
    private readonly AppDbContext _context;
    private readonly IEmailSender _emailSender;
    private readonly ILogger<ContactMessageService> _logger;

    public ContactMessageService(
        AppDbContext context,
        IEmailSender emailSender,
        ILogger<ContactMessageService> logger
    )
    {
        _context = context;
        _emailSender = emailSender;
        _logger = logger;
    }

    public async Task<ContactMessageDto> CreateAsync(CreateContactMessageDto dto, CancellationToken cancellationToken)
    {
        var name = dto.Name.Trim();
        var email = dto.Email.Trim();
        var subject = dto.Subject?.Trim();
        var messageBody = dto.Message.Trim();
        var storedMessage = string.IsNullOrWhiteSpace(subject)
            ? messageBody
            : $"Subject: {subject}{Environment.NewLine}{Environment.NewLine}{messageBody}";

        var contactMessage = new ContactMessage
        {
            Id = Guid.NewGuid(),
            Name = name,
            Email = email,
            Message = storedMessage,
            CreatedAt = DateTime.SpecifyKind(DateTime.Now, DateTimeKind.Unspecified)
        };

        _context.ContactMessages.Add(contactMessage);
        await _context.SaveChangesAsync(cancellationToken);

        try
        {
            await _emailSender.SendContactMessageAsync(
                name,
                email,
                subject,
                messageBody,
                cancellationToken
            );
        }
        catch (Exception ex)
        {
            _logger.LogWarning(
                ex,
                "Contact message {ContactMessageId} was saved, but email delivery failed.",
                contactMessage.Id
            );
        }

        return new ContactMessageDto
        {
            Id = contactMessage.Id,
            Name = contactMessage.Name,
            Email = contactMessage.Email,
            Message = contactMessage.Message,
            CreatedAt = contactMessage.CreatedAt
        };
    }
}
