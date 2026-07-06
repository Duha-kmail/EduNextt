using System;
using System.ComponentModel.DataAnnotations;
namespace backend.DTOs.Admin{

public record AchievementDto(
    [Required] string Title,
    [Required] string Description,
    [Required] string IconUrl, 
    [Required] string RequirementType, 
    int RequirementValue 
);}