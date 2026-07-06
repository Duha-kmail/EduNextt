namespace backend.DTOs.Admin
{
public record SystemAnalyticsDto(
    double SuccessRate, 
    string MostInteractiveSubject, 
    string MostCompletedLesson, 
    List<SubjectPerformanceReport> PerformanceReports 
);
public record SubjectPerformanceReport(string SubjectName, double AvgScore, int StudentCount);}