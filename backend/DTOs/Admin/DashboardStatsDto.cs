namespace backend.DTOs.Admin
{
    public record DashboardStatsDto(
    int TotalStudents,
    int TotalSubjects,
    int TotalLessons,
    int TotalExams,
    int TotalSubmittedExams,
    double AverageScore,
    double OverallSuccessRate, 
    double LessonCompletionRate, 
    string MostActiveSubject 
);
}