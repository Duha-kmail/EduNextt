using backend.DTOs.Admin;

namespace backend.Services.Admin;

public interface IAdminLessonsService
{
    Task<AdminLessonsPageDto> GetLessonsPageAsync(
        string? search,
        string? department,
        Guid? subjectId,
        string? sortBy,
        int page,
        int pageSize
    );

    Task<List<AdminLessonUnitDto>> GetUnitsBySubjectAsync(Guid subjectId);

    Task<AdminLessonUnitDto> CreateUnitAsync(Guid subjectId, CreateAdminLessonUnitDto dto);

    Task<AdminLessonDto?> CreateLessonAsync(CreateAdminLessonDto dto);

    Task<AdminLessonDto?> UpdateLessonAsync(Guid id, UpdateAdminLessonDto dto);

    Task<bool> DeleteLessonAsync(Guid id);
}