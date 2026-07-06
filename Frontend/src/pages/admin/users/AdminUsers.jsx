import React, { useEffect, useMemo, useState } from "react";
import {
  Users,
  Download,
  Search,
  Trash2,
  Ban,
  UserCog,
  Eye,
  ChevronLeft,
  ChevronRight,
  CheckCircle,
  X,
  AlertTriangle,
  Loader2,
} from "lucide-react";

import "./AdminUsers.css";
import SideBar from "../../../components/SideBar";
import { API_BASE_URL } from "@/config/api";

const ITEMS_PER_PAGE = 4;

export default function AdminUsers() {
  const [users, setUsers] = useState([]);
  const [roleOptions, setRoleOptions] = useState([]);

  const [stats, setStats] = useState({
    studentCount: 0,
    adminCount: 0,
    activeUsersCount: 0,
  });

  const [searchQuery, setSearchQuery] = useState("");
  const [roleFilter, setRoleFilter] = useState("all");
  const [statusFilter, setStatusFilter] = useState("all");

  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [totalItems, setTotalItems] = useState(0);

  const [deleteConfirm, setDeleteConfirm] = useState(null);
  const [viewUser, setViewUser] = useState(null);
  const [roleChangeUser, setRoleChangeUser] = useState(null);
  const [newRole, setNewRole] = useState("");

  const [loading, setLoading] = useState(true);
  const [tableLoading, setTableLoading] = useState(false);
  const [saving, setSaving] = useState(false);

  const [pageError, setPageError] = useState("");
  const [actionError, setActionError] = useState("");
  const [actionSuccess, setActionSuccess] = useState("");
  const [deleteError, setDeleteError] = useState("");
  const [deleteSuccess, setDeleteSuccess] = useState("");

  const token = localStorage.getItem("token");

  const authHeaders = useMemo(() => {
    return {
      "Content-Type": "application/json",
      Authorization: `Bearer ${token}`,
    };
  }, [token]);

  const normalizeUser = (user) => ({
    id: user.id || user.Id,
    displayId: user.displayId || user.DisplayId || "",
    fullName: user.fullName || user.FullName || "مستخدم بدون اسم",
    email: user.email || user.Email || "",
    role: user.role || user.Role || "",
    roleLabel: user.roleLabel || user.RoleLabel || "",
    status: user.status || user.Status || "",
    isActive: user.isActive ?? user.IsActive ?? false,
    registrationDate: user.registrationDate || user.RegistrationDate || "",
    avatar: user.avatar || user.Avatar || "👤",
    avatarColor: user.avatarColor || user.AvatarColor || "#e8f0fe",
  });

  const normalizeStats = (rawStats) => ({
    studentCount: rawStats?.studentCount ?? rawStats?.StudentCount ?? 0,
    adminCount: rawStats?.adminCount ?? rawStats?.AdminCount ?? 0,
    activeUsersCount:
      rawStats?.activeUsersCount ?? rawStats?.ActiveUsersCount ?? 0,
  });

  const normalizeRoleOption = (role) => ({
    label: role.label || role.Label || "",
    value: role.value || role.Value || "",
  });

  const readResponseBody = async (response) => {
    const rawText = await response.text();

    try {
      return JSON.parse(rawText);
    } catch {
      return { message: rawText };
    }
  };

  const showActionSuccess = (message) => {
    setActionError("");
    setActionSuccess(message);

    setTimeout(() => {
      setActionSuccess("");
    }, 2200);
  };

  const showActionError = (message) => {
    setActionSuccess("");
    setActionError(message);

    setTimeout(() => {
      setActionError("");
    }, 2600);
  };

  const loadRoles = async () => {
    const response = await fetch(`${API_BASE_URL}/api/admin/users/roles`, {
      method: "GET",
      headers: authHeaders,
    });

    const data = await readResponseBody(response);

    if (!response.ok) {
      setRoleOptions([
        { label: "طالب", value: "student" },
        { label: "مسؤول", value: "admin" },
      ]);
      return;
    }

    const roles = Array.isArray(data) ? data.map(normalizeRoleOption) : [];

    setRoleOptions(
      roles.length > 0
        ? roles
        : [
          { label: "طالب", value: "student" },
          { label: "مسؤول", value: "admin" },
        ]
    );
  };

  const loadUsers = async ({ silent = false } = {}) => {
    if (!token) {
      window.location.href = "/login";
      return;
    }

    try {
      if (silent) {
        setTableLoading(true);
      } else {
        setLoading(true);
      }

      setPageError("");

      const params = new URLSearchParams({
        page: String(currentPage),
        pageSize: String(ITEMS_PER_PAGE),
        role: roleFilter,
        status: statusFilter,
      });

      if (searchQuery.trim()) {
        params.append("search", searchQuery.trim());
      }

      const response = await fetch(
        `${API_BASE_URL}/api/admin/users?${params.toString()}`,
        {
          method: "GET",
          headers: authHeaders,
        }
      );

      const data = await readResponseBody(response);

      if (!response.ok) {
        setPageError(data.message || "فشل تحميل المستخدمين");
        return;
      }

      const pageUsers = data.users || data.Users || [];
      const pageStats = data.stats || data.Stats || {};

      setUsers(pageUsers.map(normalizeUser));
      setStats(normalizeStats(pageStats));

      setCurrentPage(data.currentPage ?? data.CurrentPage ?? currentPage);
      setTotalPages(data.totalPages ?? data.TotalPages ?? 1);
      setTotalItems(data.totalItems ?? data.TotalItems ?? 0);
    } catch (err) {
      console.error(err);
      setPageError("تعذر الاتصال بالسيرفر");
    } finally {
      setLoading(false);
      setTableLoading(false);
    }
  };

  useEffect(() => {
    const initialLoad = async () => {
      await loadRoles();
      await loadUsers({ silent: false });
    };

    initialLoad();
    
  }, []);

  useEffect(() => {
    if (!loading) {
      loadUsers({ silent: true });
    }
    
  }, [currentPage, roleFilter, statusFilter]);

  useEffect(() => {
    if (loading) return;

    const delay = setTimeout(() => {
      setCurrentPage(1);
      loadUsers({ silent: true });
    }, 400);

    return () => clearTimeout(delay);
    
  }, [searchQuery]);

  const getRoleBadgeClass = (roleLabel) => {
    switch (roleLabel) {
      case "طالب":
        return "au-badge au-badge-blue";
      case "مسؤول":
        return "au-badge au-badge-purple";
      default:
        return "au-badge";
    }
  };

  const getStatusBadgeClass = (status) => {
    return status === "نشط"
      ? "au-status au-status-active"
      : "au-status au-status-disabled";
  };

  const getVisiblePages = () => {
    const safeTotalPages = totalPages <= 0 ? 1 : totalPages;
    const pages = [];

    if (safeTotalPages <= 7) {
      for (let i = 1; i <= safeTotalPages; i++) {
        pages.push(i);
      }

      return pages;
    }

    pages.push(1);

    if (currentPage > 4) {
      pages.push("start-ellipsis");
    }

    const start = Math.max(2, currentPage - 1);
    const end = Math.min(safeTotalPages - 1, currentPage + 1);

    for (let i = start; i <= end; i++) {
      pages.push(i);
    }

    if (currentPage < safeTotalPages - 3) {
      pages.push("end-ellipsis");
    }

    pages.push(safeTotalPages);

    return pages;
  };

  const clearActionMessages = () => {
    setActionError("");
    setActionSuccess("");
  };

  const handleToggleStatus = async (user) => {
    try {
      setSaving(true);
      clearActionMessages();

      const response = await fetch(
        `${API_BASE_URL}/api/admin/users/${user.id}/status`,
        {
          method: "PATCH",
          headers: authHeaders,
          body: JSON.stringify({
            isActive: !user.isActive,
          }),
        }
      );

      const data = await readResponseBody(response);

      if (!response.ok) {
        showActionError(data.message || "فشل تحديث حالة المستخدم");
        return;
      }

      showActionSuccess(
        user.isActive
          ? "تم تعطيل المستخدم بنجاح."
          : "تم تفعيل المستخدم بنجاح."
      );

      await loadUsers({ silent: true });
    } catch (err) {
      console.error(err);
      showActionError("تعذر الاتصال بالسيرفر");
    } finally {
      setSaving(false);
    }
  };

  const handleRoleChange = async () => {
    if (!roleChangeUser || !newRole) return;

    try {
      setSaving(true);
      setActionError("");
      setActionSuccess("");

      const response = await fetch(
        `${API_BASE_URL}/api/admin/users/${roleChangeUser.id}/role`,
        {
          method: "PATCH",
          headers: authHeaders,
          body: JSON.stringify({
            role: newRole,
          }),
        }
      );

      const data = await readResponseBody(response);

      if (!response.ok) {
        setActionError(data.message || "فشل تغيير دور المستخدم");
        return;
      }

      setActionSuccess("تم تغيير دور المستخدم بنجاح.");

      await loadUsers({ silent: true });

      setTimeout(() => {
        setRoleChangeUser(null);
        setNewRole("");
        setActionSuccess("");
        setActionError("");
      }, 1200);
    } catch (err) {
      console.error(err);
      setActionError("تعذر الاتصال بالسيرفر");
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async () => {
    if (!deleteConfirm) return;

    try {
      setSaving(true);
      setDeleteError("");
      setDeleteSuccess("");

      const response = await fetch(
        `${API_BASE_URL}/api/admin/users/${deleteConfirm.id}`,
        {
          method: "DELETE",
          headers: authHeaders,
        }
      );

      const data = await readResponseBody(response);

      if (!response.ok) {
        setDeleteSuccess("");
        setDeleteError(data.message || "فشل تعطيل المستخدم");
        return;
      }

      setDeleteError("");
      setDeleteSuccess("تم تعطيل المستخدم بنجاح.");

      await loadUsers({ silent: true });

      setTimeout(() => {
        setDeleteConfirm(null);
        setDeleteError("");
        setDeleteSuccess("");
        showActionSuccess("تم تعطيل المستخدم بنجاح.");
      }, 700);
    } catch (err) {
      console.error(err);
      setDeleteSuccess("");
      setDeleteError("تعذر الاتصال بالسيرفر");
    } finally {
      setSaving(false);
    }
  };

  const handleExport = () => {
    const header = "الاسم,البريد,الدور,تاريخ التسجيل,الحالة\n";

    const rows = users
      .map(
        (u) =>
          `${u.fullName},${u.email},${u.roleLabel},${u.registrationDate},${u.status}`
      )
      .join("\n");

    const blob = new Blob(["\uFEFF" + header + rows], {
      type: "text/csv;charset=utf-8;",
    });

    const link = document.createElement("a");
    link.href = URL.createObjectURL(blob);
    link.download = "users.csv";
    link.click();
  };

  const startItem =
    totalItems === 0 ? 0 : (currentPage - 1) * ITEMS_PER_PAGE + 1;

  const endItem = Math.min(currentPage * ITEMS_PER_PAGE, totalItems);

  if (loading) {
    return (
      <SideBar
        title="إدارة المستخدمين"
        subtitle="عرض وإدارة كافة مستخدمي المنصة وتعديل أدوارهم."
        titleIcon={Users}
      >
        <div className="au-main admin-page-loading rtl">
          <Loader2 className="animate-spin" />
          <span>جاري تحميل المستخدمين...</span>
        </div>
      </SideBar>
    );
  }

  return (
    <SideBar
      title="إدارة المستخدمين"
      subtitle="عرض وإدارة كافة مستخدمي المنصة وتعديل أدوارهم."
      titleIcon={Users}
      headerContent={
        <div className="au-header-actions">
          <button className="au-btn au-btn-outline" onClick={handleExport}>
            <Download size={18} />
            <span>تصدير البيانات</span>
          </button>
        </div>
      }
    >
      <>
        {actionSuccess && !roleChangeUser && (
          <div className="au-toast au-toast-success">{actionSuccess}</div>
        )}

        {actionError && !roleChangeUser && (
          <div className="au-toast au-toast-error">{actionError}</div>
        )}

        <main className="au-main rtl">


          {pageError && (
            <div className="admin-page-message admin-page-message-error au-page-message">
              {pageError}
            </div>
          )}

          <div className="au-stats au-stats-spaced">
            <div className="au-stat-card">
              <div className="au-stat-icon au-stat-blue">
                <Users size={28} />
              </div>

              <div className="au-stat-content">
                <span className="au-stat-label">إجمالي الطلاب</span>
                <strong className="au-stat-value">
                  {stats.studentCount}
                </strong>
              </div>
            </div>

            <div className="au-stat-card">
              <div className="au-stat-icon au-stat-purple">
                <UserCog size={28} />
              </div>

              <div className="au-stat-content">
                <span className="au-stat-label">إجمالي المسؤولين</span>
                <strong className="au-stat-value">{stats.adminCount}</strong>
              </div>
            </div>

            <div className="au-stat-card">
              <div className="au-stat-icon au-stat-green">
                <Users size={28} />
              </div>

              <div className="au-stat-content">
                <span className="au-stat-label">المستخدمون النشطون</span>
                <strong className="au-stat-value">
                  {stats.activeUsersCount}
                </strong>
              </div>
            </div>
          </div>

          <div className="au-filters">
            <div className="au-search-box">
              <Search size={18} />
              <input
                type="text"
                placeholder="البحث بالاسم أو البريد الإلكتروني..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
              />
            </div>

            <div className="au-filter-group">
              <span className="au-filter-label">تصفية حسب:</span>

              <select
                value={roleFilter}
                onChange={(e) => {
                  setRoleFilter(e.target.value);
                  setCurrentPage(1);
                }}
                className="au-select"
              >
                <option value="all">جميع الأدوار</option>

                {roleOptions.map((role) => (
                  <option key={role.value} value={role.value}>
                    {role.label}
                  </option>
                ))}
              </select>

              <select
                value={statusFilter}
                onChange={(e) => {
                  setStatusFilter(e.target.value);
                  setCurrentPage(1);
                }}
                className="au-select"
              >
                <option value="all">الحالة (الكل)</option>
                <option value="active">نشط</option>
                <option value="disabled">معطل</option>
              </select>
            </div>
          </div>

          <div className="au-table-container">
            {tableLoading && (
              <div className="admin-table-loading">
                <Loader2 className="animate-spin" size={16} />
                <span>تحديث البيانات...</span>
              </div>
            )}

            <table className="au-table">
              <thead>
                <tr>
                  <th>اسم المستخدم</th>
                  <th>البريد الإلكتروني</th>
                  <th>الدور</th>
                  <th>تاريخ التسجيل</th>
                  <th>الحالة</th>
                  <th>الإجراءات</th>
                </tr>
              </thead>

              <tbody>
                {users.length === 0 ? (
                  <tr>
                    <td colSpan={6} className="admin-empty-cell">
                      لا توجد نتائج مطابقة
                    </td>
                  </tr>
                ) : (
                  users.map((user) => (
                    <tr key={user.id}>
                      <td>
                        <div className="au-user-cell">


                          <div className="au-user-info">
                            <strong>{user.fullName}</strong>
                            <span>ID: #{user.displayId}</span>
                          </div>
                        </div>
                      </td>

                      <td>{user.email}</td>

                      <td>
                        <span className={getRoleBadgeClass(user.roleLabel)}>
                          {user.roleLabel || user.role}
                        </span>
                      </td>

                      <td>{user.registrationDate}</td>

                      <td>
                        <span className={getStatusBadgeClass(user.status)}>
                          <span className="au-status-dot"></span>
                          {user.status}
                        </span>
                      </td>

                      <td>
                        <div className="au-actions">
                          <button
                            className="au-action-btn"
                            title="عرض"
                            onClick={() => setViewUser(user)}
                          >
                            <Eye size={16} />
                          </button>

                          <button
                            className="au-action-btn"
                            title="تغيير الدور"
                            onClick={() => {
                              clearActionMessages();
                              setRoleChangeUser(user);
                              setNewRole(user.role);
                            }}
                            disabled={saving}
                          >
                            <UserCog size={16} />
                          </button>

                          <button
                            className="au-action-btn"
                            title={user.isActive ? "تعطيل" : "تفعيل"}
                            onClick={() => handleToggleStatus(user)}
                            disabled={saving}
                          >
                            {user.isActive ? (
                              <Ban size={16} />
                            ) : (
                              <CheckCircle size={16} />
                            )}
                          </button>

                          <button
                            className="au-action-btn au-action-delete"
                            title="تعطيل المستخدم"
                            onClick={() => {
                              setDeleteError("");
                              setDeleteSuccess("");
                              setDeleteConfirm(user);
                            }}
                            disabled={saving || !user.isActive}
                          >
                            <Trash2 size={16} />
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>

          <div className="au-pagination">
            <span className="au-pagination-info">
              عرض {startItem} إلى {endItem} من أصل {totalItems} مستخدم
            </span>

            <div className="au-pagination-controls">
              <button
                className="au-page-btn"
                disabled={currentPage <= 1}
                onClick={() => setCurrentPage((prev) => prev - 1)}
              >
                <ChevronRight size={16} />
              </button>

              {getVisiblePages().map((page) => {
                if (typeof page === "string") {
                  return (
                    <span key={page} className="au-page-ellipsis">
                      ...
                    </span>
                  );
                }

                return (
                  <button
                    key={page}
                    className={`au-page-btn ${currentPage === page ? "active" : ""
                      }`}
                    onClick={() => setCurrentPage(page)}
                  >
                    {page}
                  </button>
                );
              })}

              <button
                className="au-page-btn"
                disabled={currentPage >= totalPages}
                onClick={() => setCurrentPage((prev) => prev + 1)}
              >
                <ChevronLeft size={16} />
              </button>
            </div>
          </div>
        </main>

        {deleteConfirm && (
          <div
            className="au-modal-overlay"
            onClick={() => {
              setDeleteConfirm(null);
              setDeleteError("");
              setDeleteSuccess("");
            }}
          >
            <div
              className="au-modal-content"
              dir="rtl"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="au-modal-icon au-modal-icon-danger">
                <AlertTriangle size={32} />
              </div>

              <h3>تعطيل المستخدم</h3>

              <p>
                هل تريد تعطيل المستخدم "{deleteConfirm.fullName}"؟ لن يتم حذف
                بياناته من قاعدة البيانات.
              </p>

              {deleteError && (
                <div className="admin-page-message admin-page-message-error au-modal-message">
                  {deleteError}
                </div>
              )}
              {deleteSuccess && (
                <div className="admin-page-message admin-page-message-success au-modal-message">
                  {deleteSuccess}
                </div>
              )}

              <div className="au-modal-actions">
                <button
                  className="au-btn au-btn-danger"
                  onClick={handleDelete}
                  disabled={saving || Boolean(deleteSuccess)}
                >
                  {saving ? "جاري التعطيل..." : "نعم، عطّل المستخدم"}
                </button>

                <button
                  className="au-btn au-btn-outline"
                  onClick={() => {
                    setDeleteConfirm(null);
                    setDeleteError("");
                    setDeleteSuccess("");
                  }}
                  disabled={saving}
                >
                  إلغاء
                </button>
              </div>
            </div>
          </div>
        )}

        {viewUser && (
          <div
            className="au-modal-overlay"
            onClick={() => setViewUser(null)}
          >
            <div
              className="au-modal-content au-modal-view"
              dir="rtl"
              onClick={(e) => e.stopPropagation()}
            >
              <button
                className="au-form-close"
                onClick={() => setViewUser(null)}
              >
                <X size={20} />
              </button>

              <div className="au-view-header">

                <h3>{viewUser.fullName}</h3>

                <span className={getRoleBadgeClass(viewUser.roleLabel)}>
                  {viewUser.roleLabel}
                </span>
              </div>

              <div className="au-view-details">
                <div className="au-view-row">
                  <span className="au-view-label">المعرف:</span>
                  <span>#{viewUser.displayId}</span>
                </div>

                <div className="au-view-row">
                  <span className="au-view-label">البريد:</span>
                  <span>{viewUser.email}</span>
                </div>

                <div className="au-view-row">
                  <span className="au-view-label">تاريخ التسجيل:</span>
                  <span>{viewUser.registrationDate}</span>
                </div>

                <div className="au-view-row">
                  <span className="au-view-label">الحالة:</span>
                  <span className={getStatusBadgeClass(viewUser.status)}>
                    <span className="au-status-dot"></span>
                    {viewUser.status}
                  </span>
                </div>
              </div>
            </div>
          </div>
        )}

        {roleChangeUser && (
          <div
            className="au-modal-overlay"
            onClick={() => {
              setRoleChangeUser(null);
              setNewRole("");
              setActionError("");
              setActionSuccess("");
            }}
          >
            <div
              className="au-modal-content"
              dir="rtl"
              onClick={(e) => e.stopPropagation()}
            >
              <h3>تغيير دور المستخدم</h3>

              <p>تغيير دور "{roleChangeUser.fullName}" إلى:</p>

              <select
                className="au-select au-modal-select"
                value={newRole}
                onChange={(e) => {
                  setNewRole(e.target.value);
                  setActionError("");
                  setActionSuccess("");
                }}
              >
                {roleOptions.map((role) => (
                  <option key={role.value} value={role.value}>
                    {role.label}
                  </option>
                ))}
              </select>

              {actionError && (
                <div className="admin-page-message admin-page-message-error au-modal-message">
                  {actionError}
                </div>
              )}

              {actionSuccess && (
                <div className="admin-page-message admin-page-message-success au-modal-message">
                  {actionSuccess}
                </div>
              )}

              <div className="au-modal-actions">
                <button
                  className="au-btn au-btn-primary"
                  onClick={handleRoleChange}
                  disabled={saving || Boolean(actionSuccess)}
                >
                  {saving ? "جاري الحفظ..." : "حفظ التغيير"}
                </button>

                <button
                  className="au-btn au-btn-outline"
                  onClick={() => {
                    setRoleChangeUser(null);
                    setNewRole("");
                    setActionError("");
                    setActionSuccess("");
                  }}
                  disabled={saving}
                >
                  إلغاء
                </button>
              </div>
            </div>
          </div>
        )}
      </>
    </SideBar>
  );
}
