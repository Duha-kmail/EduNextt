namespace backend.DTOs.Auth;

public class VerifyRegistrationRequestDto
{
    public string Email { get; set; } = "";
    public string Otp { get; set; } = "";
}
