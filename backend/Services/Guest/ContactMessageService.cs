using backend.Data.Generated;
using backend.DTOs.Guest;
using backend.Models;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace backend.Services.Guest;

public class ContactMessageService : IContactMessageService
{
    private readonly AppDbContext _context;

    public ContactMessageService(AppDbContext context)
    {
        _context = context;
    }

    public async Task<ContactMessageDto> CreateAsync(CreateContactMessageDto dto, CancellationToken cancellationToken)
    {
        await EnsureContactMessagesSchemaAsync(cancellationToken);

        var name = dto.Name.Trim();
        var email = dto.Email.Trim();
        var subject = dto.Subject?.Trim();
        var messageBody = dto.Message.Trim();

        var contactMessage = new ContactMessage
        {
            Id = Guid.NewGuid(),
            Name = name,
            Email = email,
            Subject = string.IsNullOrWhiteSpace(subject) ? null : subject,
            Message = messageBody,
            CreatedAt = DateTime.UtcNow
        };

        _context.ContactMessages.Add(contactMessage);
        await _context.SaveChangesAsync(cancellationToken);

        return new ContactMessageDto
        {
            Id = contactMessage.Id,
            Name = contactMessage.Name,
            Email = contactMessage.Email,
            Subject = contactMessage.Subject,
            Message = contactMessage.Message,
            CreatedAt = contactMessage.CreatedAt
        };
    }

    public async Task<IReadOnlyList<ContactMessageDto>> GetAllAsync(CancellationToken cancellationToken)
    {
        await EnsureContactMessagesSchemaAsync(cancellationToken);

        return await _context.ContactMessages
            .AsNoTracking()
            .OrderByDescending(message => message.CreatedAt)
            .Select(message => new ContactMessageDto
            {
                Id = message.Id,
                Name = message.Name,
                Email = message.Email,
                Subject = message.Subject,
                Message = message.Message,
                CreatedAt = message.CreatedAt
            })
            .ToListAsync(cancellationToken);
    }

    public async Task<bool> DeleteAsync(Guid id, CancellationToken cancellationToken)
    {
        await EnsureContactMessagesSchemaAsync(cancellationToken);

        var message = await _context.ContactMessages
            .FirstOrDefaultAsync(item => item.Id == id, cancellationToken);

        if (message is null)
        {
            return false;
        }

        _context.ContactMessages.Remove(message);
        await _context.SaveChangesAsync(cancellationToken);

        return true;
    }

    private async Task EnsureContactMessagesSchemaAsync(CancellationToken cancellationToken)
    {
        var connection = _context.Database.GetDbConnection();
        var shouldClose = connection.State != ConnectionState.Open;

        if (shouldClose)
        {
            await connection.OpenAsync(cancellationToken);
        }

        try
        {
            await using var command = connection.CreateCommand();
            command.CommandText = """
                CREATE TABLE IF NOT EXISTS public."ContactMessages" (
                    "Id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
                    "Name" character varying(255) NOT NULL,
                    "Email" character varying(255) NOT NULL,
                    "Subject" character varying(150),
                    "Message" text NOT NULL,
                    "CreatedAt" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
                );

                ALTER TABLE public."ContactMessages"
                ADD COLUMN IF NOT EXISTS "Subject" character varying(150);
                """;

            await command.ExecuteNonQueryAsync(cancellationToken);
        }
        finally
        {
            if (shouldClose)
            {
                await connection.CloseAsync();
            }
        }
    }
}
