using backend.Data.Generated;
using backend.DTOs.Admin;
using backend.Models.Generated;
using Microsoft.EntityFrameworkCore;

namespace backend.Repositories.Admin;

public class AdminLessonsRepository : IAdminLessonsRepository
{
    private readonly AppDbContext _context;

    public AdminLessonsRepository(AppDbContext context)
    {
        _context = context;
    }

    public async Task<AdminLessonsPageDto> GetLessonsPageAsync(
        string? search,
        string? department,
        Guid? subjectId,
        string? sortBy,
        int page,
        int pageSize
    )
    {
        page = page <= 0 ? 1 : page;
        pageSize = pageSize <= 0 ? 4 : pageSize;

        var query = _context.lessons
            .AsNoTracking()
            .Include(l => l.subject)
            .AsQueryable();

        if (!string.IsNullOrWhiteSpace(search))
        {
            var normalizedSearch = search.Trim().ToLower();

            query = query.Where(l =>
                l.title.ToLower().Contains(normalizedSearch) ||
                (l.subject != null && l.subject.name.ToLower().Contains(normalizedSearch)) ||
                (l.order_number != null && l.order_number.ToString()!.Contains(normalizedSearch))
            );
        }

        if (!string.IsNullOrWhiteSpace(department) && department != "all")
        {
            query = query.Where(l =>
                l.subject != null &&
                l.subject.stream == department
            );
        }

        if (subjectId.HasValue)
        {
            query = query.Where(l => l.subject_id == subjectId.Value);
        }

        var totalItems = await query.CountAsync();

        var totalPages = totalItems == 0
            ? 1
            : (int)Math.Ceiling((double)totalItems / pageSize);

        if (page > totalPages)
        {
            page = totalPages;
        }

        var lessonsRaw = await query
            .Select(l => new
            {
                LessonId = l.id,
                LessonTitle = l.title,
                SubjectId = l.subject_id,
                SubjectName = l.subject != null ? l.subject.name : "",
                SubjectDepartment = l.subject != null ? l.subject.stream ?? "" : "",
                Description = l.summary,
                Content = l.content,
                LessonOrder = l.order_number,
                VideoUrl = l.video_url,
                PdfUrl = l.pdf_url,
                ResourcesUrl = l.resources_url,
                SubjectUnitId = l.subject_unit_id
            })
            .ToListAsync();

        var unitIds = lessonsRaw
            .Where(l => l.SubjectUnitId != null)
            .Select(l => l.SubjectUnitId!.Value)
            .Distinct()
            .ToList();

        var units = await _context.subject_units
            .AsNoTracking()
            .Where(u => unitIds.Contains(u.id))
            .Select(u => new
            {
                UnitId = u.id,
                UnitTitle = u.title,
                UnitOrder = u.order_number
            })
            .ToListAsync();

        var unitById = units.ToDictionary(u => u.UnitId);

        var orderedLessons = lessonsRaw
            .Select(l =>
            {
                var unit = l.SubjectUnitId != null &&
                           unitById.ContainsKey(l.SubjectUnitId.Value)
                    ? unitById[l.SubjectUnitId.Value]
                    : null;

                return new AdminLessonDto
                {
                    Id = l.LessonId,
                    Title = l.LessonTitle ?? "",
                    SubjectId = l.SubjectId,
                    SubjectName = l.SubjectName ?? "",
                    SubjectDepartment = l.SubjectDepartment ?? "",
                    Description = l.Description ?? "",
                    Content = l.Content ?? "",
                    Order = l.LessonOrder ?? 0,
                    UnitId = l.SubjectUnitId,
                    UnitOrder = unit?.UnitOrder,
                    UnitTitle = unit?.UnitTitle ?? "",
                    VideoUrl = l.VideoUrl ?? "",
                    PdfUrl = l.PdfUrl ?? "",
                    ResourcesUrl = l.ResourcesUrl ?? ""
                };
            })
            .ToList();

        orderedLessons = sortBy switch
        {
            "title" => orderedLessons
                .OrderBy(l => l.Title)
                .ToList(),

            "subject" => orderedLessons
                .OrderBy(l => l.SubjectDepartment)
                .ThenBy(l => l.SubjectName)
                .ThenBy(l => l.UnitOrder ?? int.MaxValue)
                .ThenBy(l => l.Order)
                .ThenBy(l => l.Title)
                .ToList(),

            "order" => orderedLessons
                .OrderBy(l => l.UnitOrder ?? int.MaxValue)
                .ThenBy(l => l.Order)
                .ThenBy(l => l.Title)
                .ToList(),

            _ => orderedLessons
                .OrderBy(l => l.SubjectDepartment)
                .ThenBy(l => l.SubjectName)
                .ThenBy(l => l.UnitOrder ?? int.MaxValue)
                .ThenBy(l => l.Order)
                .ThenBy(l => l.Title)
                .ToList()
        };

        var lessons = orderedLessons
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToList();

        var subjects = await GetSubjectsAsync();

        return new AdminLessonsPageDto
        {
            Lessons = lessons,
            Subjects = subjects,
            CurrentPage = page,
            TotalPages = totalPages,
            TotalItems = totalItems,
            PageSize = pageSize
        };
    }

    public async Task<List<AdminLessonUnitDto>> GetUnitsBySubjectAsync(Guid subjectId)
    {
        if (subjectId == Guid.Empty)
        {
            return new List<AdminLessonUnitDto>();
        }

        return await _context.subject_units
            .AsNoTracking()
            .Where(u => u.subject_id == subjectId)
            .OrderBy(u => u.order_number)
            .ThenBy(u => u.title)
            .Select(u => new AdminLessonUnitDto
            {
                Id = u.id,
                Title = u.title ?? "",
                OrderNumber = u.order_number
            })
            .ToListAsync();
    }

    public async Task<AdminLessonUnitDto> CreateUnitAsync(Guid subjectId, CreateAdminLessonUnitDto dto)
    {
        if (subjectId == Guid.Empty)
        {
            throw new ArgumentException("يجب اختيار المادة.");
        }

        if (dto == null || string.IsNullOrWhiteSpace(dto.Title))
        {
            throw new ArgumentException("عنوان الوحدة مطلوب.");
        }

        var subjectExists = await _context.subjects
            .AsNoTracking()
            .AnyAsync(s => s.id == subjectId);

        if (!subjectExists)
        {
            throw new ArgumentException("المادة غير موجودة.");
        }

        var title = dto.Title.Trim();

        var duplicateExists = await _context.subject_units
            .AsNoTracking()
            .AnyAsync(u =>
                u.subject_id == subjectId &&
                u.title.ToLower() == title.ToLower()
            );

        if (duplicateExists)
        {
            throw new ArgumentException("توجد وحدة بنفس الاسم داخل هذه المادة.");
        }

        var unit = new subject_unit
        {
            id = Guid.NewGuid(),
            subject_id = subjectId,
            title = title,
            order_number = dto.OrderNumber <= 0 ? 1 : dto.OrderNumber,
            created_at = DateTime.Now
        };

        _context.subject_units.Add(unit);
        AddAdminLog("create_subject_unit", $"Created unit {title}");
        await _context.SaveChangesAsync();

        return new AdminLessonUnitDto
        {
            Id = unit.id,
            Title = unit.title ?? "",
            OrderNumber = unit.order_number
        };
    }

    public async Task<AdminLessonDto?> CreateLessonAsync(CreateAdminLessonDto dto)
    {
        if (dto.SubjectId == Guid.Empty)
        {
            throw new ArgumentException("اختيار المادة مطلوب.");
        }

        if (dto.UnitId == Guid.Empty)
        {
            throw new ArgumentException("اختيار الوحدة مطلوب قبل إضافة الدرس.");
        }

        if (string.IsNullOrWhiteSpace(dto.Title))
        {
            throw new ArgumentException("عنوان الدرس مطلوب.");
        }

        var subjectExists = await _context.subjects
            .AsNoTracking()
            .AnyAsync(s => s.id == dto.SubjectId);

        if (!subjectExists)
        {
            throw new ArgumentException("المادة غير موجودة.");
        }

        var unitExists = await _context.subject_units
            .AsNoTracking()
            .AnyAsync(u => u.id == dto.UnitId && u.subject_id == dto.SubjectId);

        if (!unitExists)
        {
            throw new ArgumentException("الوحدة غير موجودة أو لا تنتمي لهذه المادة.");
        }

        var title = dto.Title.Trim();

        var duplicateExists = await _context.lessons
            .AsNoTracking()
            .AnyAsync(l =>
                l.subject_id == dto.SubjectId &&
                l.subject_unit_id == dto.UnitId &&
                l.title.ToLower() == title.ToLower()
            );

        if (duplicateExists)
        {
            throw new ArgumentException("يوجد درس بنفس الاسم داخل نفس الوحدة.");
        }

        var lesson = new lesson
        {
            id = Guid.NewGuid(),
            subject_id = dto.SubjectId,
            subject_unit_id = dto.UnitId,
            title = title,
            summary = string.IsNullOrWhiteSpace(dto.Description)
                ? null
                : dto.Description.Trim(),
            content = string.IsNullOrWhiteSpace(dto.Content)
                ? null
                : dto.Content.Trim(),
            order_number = dto.Order <= 0 ? 1 : dto.Order,
            video_url = string.IsNullOrWhiteSpace(dto.VideoUrl)
                ? null
                : dto.VideoUrl.Trim()
        };

        _context.lessons.Add(lesson);
        AddAdminLog("create_lesson", $"Created lesson {title}");
        await _context.SaveChangesAsync();

        return await GetLessonDtoByIdAsync(lesson.id);
    }

    public async Task<AdminLessonDto?> UpdateLessonAsync(Guid id, UpdateAdminLessonDto dto)
    {
        if (dto.SubjectId == Guid.Empty)
        {
            throw new ArgumentException("اختيار المادة مطلوب.");
        }

        if (dto.UnitId == Guid.Empty)
        {
            throw new ArgumentException("اختيار الوحدة مطلوب قبل تعديل الدرس.");
        }

        if (string.IsNullOrWhiteSpace(dto.Title))
        {
            throw new ArgumentException("عنوان الدرس مطلوب.");
        }

        var lesson = await _context.lessons
            .FirstOrDefaultAsync(l => l.id == id);

        if (lesson == null)
        {
            return null;
        }

        var subjectExists = await _context.subjects
            .AsNoTracking()
            .AnyAsync(s => s.id == dto.SubjectId);

        if (!subjectExists)
        {
            throw new ArgumentException("المادة غير موجودة.");
        }

        var unitExists = await _context.subject_units
            .AsNoTracking()
            .AnyAsync(u => u.id == dto.UnitId && u.subject_id == dto.SubjectId);

        if (!unitExists)
        {
            throw new ArgumentException("الوحدة غير موجودة أو لا تنتمي لهذه المادة.");
        }

        var title = dto.Title.Trim();

        var duplicateExists = await _context.lessons
            .AsNoTracking()
            .AnyAsync(l =>
                l.id != id &&
                l.subject_id == dto.SubjectId &&
                l.subject_unit_id == dto.UnitId &&
                l.title.ToLower() == title.ToLower()
            );

        if (duplicateExists)
        {
            throw new ArgumentException("يوجد درس بنفس الاسم داخل نفس الوحدة.");
        }

        lesson.subject_id = dto.SubjectId;
        lesson.subject_unit_id = dto.UnitId;
        lesson.title = title;
        lesson.summary = string.IsNullOrWhiteSpace(dto.Description)
            ? null
            : dto.Description.Trim();
        lesson.content = string.IsNullOrWhiteSpace(dto.Content)
            ? null
            : dto.Content.Trim();
        lesson.order_number = dto.Order <= 0 ? 1 : dto.Order;
        lesson.video_url = string.IsNullOrWhiteSpace(dto.VideoUrl)
            ? null
            : dto.VideoUrl.Trim();

        AddAdminLog("update_lesson", $"Updated lesson {title}");
        await _context.SaveChangesAsync();

        return await GetLessonDtoByIdAsync(lesson.id);
    }

    public async Task<bool> DeleteLessonAsync(Guid id)
    {
        var lesson = await _context.lessons
            .FirstOrDefaultAsync(l => l.id == id);

        if (lesson == null)
        {
            return false;
        }

        AddAdminLog("delete_lesson", $"Deleted lesson {lesson.title}");
        _context.lessons.Remove(lesson);
        await _context.SaveChangesAsync();

        return true;
    }

    private async Task<AdminLessonDto?> GetLessonDtoByIdAsync(Guid id)
    {
        var lessonRaw = await _context.lessons
            .AsNoTracking()
            .Include(l => l.subject)
            .Where(l => l.id == id)
            .Select(l => new
            {
                LessonId = l.id,
                LessonTitle = l.title,
                SubjectId = l.subject_id,
                SubjectName = l.subject != null ? l.subject.name : "",
                SubjectDepartment = l.subject != null ? l.subject.stream ?? "" : "",
                Description = l.summary,
                Content = l.content,
                LessonOrder = l.order_number,
                VideoUrl = l.video_url,
                PdfUrl = l.pdf_url,
                ResourcesUrl = l.resources_url,
                SubjectUnitId = l.subject_unit_id
            })
            .FirstOrDefaultAsync();

        if (lessonRaw == null)
        {
            return null;
        }

        var unit = lessonRaw.SubjectUnitId == null
            ? null
            : await _context.subject_units
                .AsNoTracking()
                .Where(u => u.id == lessonRaw.SubjectUnitId.Value)
                .Select(u => new
                {
                    UnitId = u.id,
                    UnitTitle = u.title,
                    UnitOrder = u.order_number
                })
                .FirstOrDefaultAsync();

        return new AdminLessonDto
        {
            Id = lessonRaw.LessonId,
            Title = lessonRaw.LessonTitle ?? "",
            SubjectId = lessonRaw.SubjectId,
            SubjectName = lessonRaw.SubjectName ?? "",
            SubjectDepartment = lessonRaw.SubjectDepartment ?? "",
            Description = lessonRaw.Description ?? "",
            Content = lessonRaw.Content ?? "",
            Order = lessonRaw.LessonOrder ?? 0,
            UnitId = lessonRaw.SubjectUnitId,
            UnitOrder = unit?.UnitOrder,
            UnitTitle = unit?.UnitTitle ?? "",
            VideoUrl = lessonRaw.VideoUrl ?? "",
            PdfUrl = lessonRaw.PdfUrl ?? "",
            ResourcesUrl = lessonRaw.ResourcesUrl ?? ""
        };
    }

    private void AddAdminLog(string actionType, string description)
    {
        _context.admin_logs.Add(new admin_log
        {
            id = Guid.NewGuid(),
            action_type = actionType,
            description = description,
            created_at = DateTime.Now
        });
    }

    private async Task<List<AdminLessonSubjectDto>> GetSubjectsAsync()
    {
        return await _context.subjects
            .AsNoTracking()
            .OrderBy(s => s.stream)
            .ThenBy(s => s.name)
            .Select(s => new AdminLessonSubjectDto
            {
                Id = s.id,
                Name = s.name ?? "",
                Department = s.stream ?? ""
            })
            .ToListAsync();
    }
}