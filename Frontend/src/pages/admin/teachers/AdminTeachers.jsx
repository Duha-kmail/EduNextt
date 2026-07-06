import { GraduationCap } from "lucide-react";
import SideBar from "../../../components/SideBar";
import "./AdminTeachers.css";

const AdminTeachers = () => {
  return (
    <SideBar
      title="إدارة المعلمين"
      subtitle="إدارة بيانات المعلمين وصلاحياتهم"
      titleIcon={GraduationCap}
    >
      <main className="admin-teachers-main">
        <section className="admin-teachers-coming-soon" aria-label="قريبا">
          <div className="admin-teachers-icon">
            <GraduationCap size={34} />
          </div>
          <h2>قريبا</h2>
        </section>
      </main>
    </SideBar>
  );
};

export default AdminTeachers;
