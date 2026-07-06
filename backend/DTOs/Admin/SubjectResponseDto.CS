namespace backend.DTOs.Admin{

public record SubjectResponseDto(
    Guid Id, 
    string Title, 
    int LessonsCount, 
    int ExamsCount
);}