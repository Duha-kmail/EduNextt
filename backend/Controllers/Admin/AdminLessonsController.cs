using backend.DTOs.Admin;
using backend.Services.Admin;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace backend.Controllers.Admin;

[ApiController]
[Route("api/admin/lessons")]
[Authorize(Roles = "admin")]
public class AdminLessonsController : ControllerBase
{
    private readonly IAdminLessonsService _lessonsService;

    public AdminLessonsController(IAdminLessonsService lessonsService)
    {
        _lessonsService = lessonsService;
    }

    [HttpGet]
    public async Task<IActionResult> GetLessons(
        [FromQuery] string? search,
        [FromQuery] string? department,
        [FromQuery] Guid? subjectId,
        [FromQuery] string? sortBy = "default",
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 4
    )
    {
        var result = await _lessonsService.GetLessonsPageAsync(
            search,
            department,
            subjectId,
            sortBy,
            page,
            pageSize
        );

        return Ok(result);
    }

    [HttpGet("subjects/{subjectId:guid}/units")]
    public async Task<IActionResult> GetUnitsBySubject(Guid subjectId)
    {
        var result = await _lessonsService.GetUnitsBySubjectAsync(subjectId);
        return Ok(result);
    }

    [HttpPost("subjects/{subjectId:guid}/units")]
    public async Task<IActionResult> CreateUnit(Guid subjectId, [FromBody] CreateAdminLessonUnitDto dto)
    {
        try
        {
            var result = await _lessonsService.CreateUnitAsync(subjectId, dto);
            return Ok(result);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(new
            {
                message = ex.Message
            });
        }
    }

    [HttpPost]
    public async Task<IActionResult> CreateLesson([FromBody] CreateAdminLessonDto dto)
    {
        try
        {
            var result = await _lessonsService.CreateLessonAsync(dto);

            if (result == null)
            {
                return BadRequest(new
                {
                    message = "البيانات غير صحيحة، أو يوجد درس بنفس الاسم داخل نفس الوحدة."
                });
            }

            return Ok(result);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(new
            {
                message = ex.Message
            });
        }
    }

    [HttpPut("{id:guid}")]
    public async Task<IActionResult> UpdateLesson(Guid id, [FromBody] UpdateAdminLessonDto dto)
    {
        try
        {
            var result = await _lessonsService.UpdateLessonAsync(id, dto);

            if (result == null)
            {
                return BadRequest(new
                {
                    message = "الدرس غير موجود، أو البيانات غير صحيحة، أو يوجد درس بنفس الاسم داخل نفس الوحدة."
                });
            }

            return Ok(result);
        }
        catch (ArgumentException ex)
        {
            return BadRequest(new
            {
                message = ex.Message
            });
        }
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> DeleteLesson(Guid id)
    {
        try
        {
            var deleted = await _lessonsService.DeleteLessonAsync(id);

            if (!deleted)
            {
                return NotFound(new
                {
                    message = "الدرس غير موجود."
                });
            }

            return Ok(new
            {
                message = "تم حذف الدرس بنجاح."
            });
        }
        catch (DbUpdateException)
        {
            return Conflict(new
            {
                message = "لا يمكن حذف هذا الدرس لأنه مرتبط ببيانات أخرى مثل امتحانات أو تقدم الطلاب."
            });
        }
    }
}