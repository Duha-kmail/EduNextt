using System;
using System.ComponentModel.DataAnnotations;

namespace backend.DTOs.Admin
{
    public record CreateLessonDto
    (
        [Required] 
        Guid SubjectId,
    [Required, MaxLength(150)] 
    string Title,
    [MaxLength(500)] 
    string VideoUrl, 
    string Summary, 
    string Content, 
    [Range(1, int.MaxValue)]
     int OrderNumber 
    );
}