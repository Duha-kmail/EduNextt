import { GraduationCap } from "lucide-react";
import SideBar from "../../../components/SideBar";
import "./StudentTeachers.css";

const StudentTeachers = () => {
  return (
    <SideBar
      title="المعلمون المتاحون"
      subtitle="استعرض المعلمين المتاحين للتواصل والدعم"
      titleIcon={GraduationCap}
    >
      <main className="student-teachers-main">
        <section className="student-teachers-coming-soon" aria-label="قريبا">
          <div className="student-teachers-icon">
            <GraduationCap size={34} />
          </div>
          <h2>قريبا</h2>
        </section>
      </main>
    </SideBar>
  );
};

export default StudentTeachers;
