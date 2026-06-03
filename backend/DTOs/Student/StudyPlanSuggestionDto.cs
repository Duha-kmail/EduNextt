namespace backend.DTOs.Student;

public class StudyPlanSuggestionDto
{
    public string RecommendationText { get; set; } = "";
    public List<string> FocusSubjects { get; set; } = new();
    public int WeeklyStudyHours { get; set; }
    public List<string> LessonOrder { get; set; } = new();
    public Guid? SubjectId { get; set; }
    public List<Guid> LessonIds { get; set; } = new();
    public List<StudyPlanSuggestedPlanDto> SuggestedPlans { get; set; } = new();
}

public class StudyPlanSuggestedPlanDto
{
    public Guid SubjectId { get; set; }
    public string SubjectName { get; set; } = "";
    public List<Guid> LessonIds { get; set; } = new();
    public List<string> LessonTitles { get; set; } = new();
}
