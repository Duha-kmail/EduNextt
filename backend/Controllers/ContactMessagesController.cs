using backend.DTOs.Guest;
using backend.Services.Guest;
using Microsoft.AspNetCore.Mvc;

namespace backend.Controllers;

[ApiController]
[Route("api/contact-messages")]
public class ContactMessagesController : ControllerBase
{
    private readonly IContactMessageService _contactMessageService;

    public ContactMessagesController(IContactMessageService contactMessageService)
    {
        _contactMessageService = contactMessageService;
    }

    [HttpPost]
    public async Task<IActionResult> Create(
        [FromBody] CreateContactMessageDto dto,
        CancellationToken cancellationToken
    )
    {
        if (
            string.IsNullOrWhiteSpace(dto.Name) ||
            string.IsNullOrWhiteSpace(dto.Email) ||
            string.IsNullOrWhiteSpace(dto.Message)
        )
        {
            return BadRequest(new
            {
                message = "Name, email, and message are required."
            });
        }

        var result = await _contactMessageService.CreateAsync(dto, cancellationToken);

        return CreatedAtAction(nameof(Create), new { id = result.Id }, new
        {
            message = "Contact message received successfully.",
            contactMessage = result
        });
    }
}
