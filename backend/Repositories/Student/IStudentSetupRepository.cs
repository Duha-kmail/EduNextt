using backend.Models.Generated;

namespace backend.Repositories.Student;

public interface IStudentSetupRepository
{
    Task<user?> GetUserByIdAsync(Guid userId);

    Task<student_profile?> GetProfileForReadAsync(Guid userId);

    Task<student_profile?> GetProfileForUpdateAsync(Guid userId);

    Task<student_profile?> GetProfileWithSubjectsForUpdateAsync(Guid userId);

    student_profile CreateProfile(Guid userId, DateTime utcNow);

    Task<List<subject>> GetSubjectsByIdsAsync(List<Guid> subjectIds);

    Task<List<subject>> GetSubjectsByBranchAndNamesAsync(string branch, List<string> subjectNames);

    Task<bool> BranchExistsAsync(string branch);

    Task<List<subject>> GetAllSubjectsForOnboardingAsync();

    Task<student_preference?> GetPreferenceForUpdateAsync(Guid userId);

    student_preference CreatePreference(Guid userId, DateTime now);

    void RemovePreferenceLearningMethods(IEnumerable<student_preference_learning_method> methods);

    void RemovePreferenceDifficultSubjects(IEnumerable<student_preference_difficult_subject> subjects);

    void AddPreferenceLearningMethod(student_preference_learning_method method);

    void AddPreferenceDifficultSubject(student_preference_difficult_subject subject);

    void RemoveProfileSubjects(IEnumerable<student_profile_subject> subjects);

    void AddProfileSubject(student_profile_subject profileSubject);

    void AddAiRecommendation(ai_recommendation recommendation);

    Task SaveChangesAsync();
}
