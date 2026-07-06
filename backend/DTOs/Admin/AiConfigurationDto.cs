using System;
using System.ComponentModel.DataAnnotations;

namespace backend.DTOs.Admin;

public record AiConfigurationDto(
    [Required] string ModelName, 
    [Required] string SystemInstruction, 
    double Temperature 
);