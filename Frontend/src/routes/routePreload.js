export const preloadAdminHome = () => {
  void Promise.all([
    import("../pages/admin/dashboard/MainDashboard.jsx"),
    import("../components/SideBar.jsx"),
  ]);
};

export const preloadStudentHome = () => {
  void Promise.all([
    import("../pages/student/dashboard/Dashboard.jsx"),
    import("../components/SideBar.jsx"),
  ]);
};
