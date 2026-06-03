using backend.DTOs.Guest;

namespace backend.Services.Guest;

public interface IContactMessageService
{
    Task<ContactMessageDto> CreateAsync(CreateContactMessageDto dto, CancellationToken cancellationToken);
}
