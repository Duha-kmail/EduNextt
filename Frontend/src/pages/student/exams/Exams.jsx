import { useEffect, useMemo, useState } from "react";
import { motion } from "framer-motion";
import { useNavigate } from "react-router-dom";
import {
  FileText,
  Award,
  BookMarked,
  Atom,
  Languages,
  FlaskConical,
  Plus,
  Filter,
  BookOpen,
  Dna,
  Loader2,
  Eye,
  Trash2,
} from "lucide-react";
import SideBar from "../../../components/SideBar";
import { API_BASE_URL } from "@/config/api";
import "./Exams.css";

const iconMap = {
  math: BookMarked,
  physics: Atom,
  arabic: Languages,
  chemistry: FlaskConical,
  english: Languages,
  biology: Dna,
  subject: BookOpen,
};

const colorMap = {
  math: "blue",
  physics: "green",
  arabic: "amber",
  chemistry: "purple",
  english: "blue",
  biology: "green",
  subject: "blue",
};

const getAuthToken = () => {
  return sessionStorage.getItem("token") || localStorage.getItem("token");
};

const normalizeExamRecord = (exam) => ({
  examResultId: exam.examResultId || exam.ExamResultId,
  examId: exam.examId || exam.ExamId,
  subjectId: exam.subjectId || exam.SubjectId,
  subjectName: exam.subjectName || exam.SubjectName || "",
  subject: exam.subjectKey || exam.SubjectKey || "subject",
  lessonId: exam.lessonId || exam.LessonId || null,
  lessonTitle: exam.lessonTitle || exam.LessonTitle || null,
  type: exam.type || exam.Type || "",
  typeName: exam.typeName || exam.TypeName || "",
  score: exam.score ?? exam.Score ?? 0,
  total: exam.questionsCount ?? exam.QuestionsCount ?? 0,
  percentage: exam.percentage ?? exam.Percentage ?? 0,
  date: exam.date || exam.Date || "",
});

const isShortType = (type) => {
  return type === "short" || type === "quick";
};

const Exams = () => {
  const navigate = useNavigate();
  const token = getAuthToken();

  const [records, setRecords] = useState([]);
  const [loading, setLoading] = useState(true);
  const [pageError, setPageError] = useState("");
  const [deleteError, setDeleteError] = useState("");
  const [deletingResultId, setDeletingResultId] = useState(null);
  const [pendingDeleteExam, setPendingDeleteExam] = useState(null);

  const [filterType, setFilterType] = useState("all");
  const [filterSubject, setFilterSubject] = useState("all");

  useEffect(() => {
    const fetchExamHistory = async () => {
      if (!token) {
        navigate("/login");
        return;
      }

      try {
        setLoading(true);
        setPageError("");

        const response = await fetch(`${API_BASE_URL}/api/student/exams`, {
          method: "GET",
          headers: {
            Authorization: `Bearer ${token}`,
          },
        });

        const rawText = await response.text();
        let data;

        try {
          data = JSON.parse(rawText);
        } catch {
          data = [];
        }

        if (!response.ok) {
          setPageError(data?.message || "فشل تحميل سجل الامتحانات");
          return;
        }

        setRecords((Array.isArray(data) ? data : []).map(normalizeExamRecord));
      } catch (err) {
        console.error(err);
        setPageError("تعذر الاتصال بالسيرفر");
      } finally {
        setLoading(false);
      }
    };

    fetchExamHistory();
  }, [token, navigate]);

  const handleDeleteResult = async (examResultId) => {
    try {
      setDeletingResultId(examResultId);
      setDeleteError("");

      const response = await fetch(
        `${API_BASE_URL}/api/student/exams/results/${examResultId}`,
        {
          method: "DELETE",
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );

      if (!response.ok) {
        const data = await response.json();
        throw new Error(data?.message || "فشل حذف نتيجة الامتحان.");
      }

      setRecords((prev) => prev.filter((record) => record.examResultId !== examResultId));
      setPendingDeleteExam(null);
    } catch (err) {
      console.error(err);
      setDeleteError(err.message || "تعذر حذف نتيجة الامتحان.");
    } finally {
      setDeletingResultId(null);
    }
  };

  const filteredRecords = useMemo(() => {
    return records.filter((record) => {
      if (filterType === "comprehensive" && record.type !== "comprehensive") {
        return false;
      }

      if (filterType === "short" && !isShortType(record.type)) {
        return false;
      }

      if (filterSubject !== "all" && record.subject !== filterSubject) {
        return false;
      }

      return true;
    });
  }, [records, filterType, filterSubject]);

  const uniqueSubjects = useMemo(() => {
    const map = new Map();

    records.forEach((record) => {
      if (!map.has(record.subject)) {
        map.set(record.subject, {
          key: record.subject,
          name: record.subjectName,
        });
      }
    });

    return Array.from(map.values());
  }, [records]);

  const showNoRecords = !loading && !pageError && filteredRecords.length === 0;

  return (
    <SideBar title="الامتحانات" subtitle="اختبر معلوماتك وتابع تقدمك" titleIcon={FileText}>
      <div className="exams-toolbar">
        <div className="exams-filter-row exams-filter-row-compact">
          <Filter size={16} className="exams-filter-icon" />

          {[
            ["all", "الكل"],
            ["comprehensive", "شامل"],
            ["short", "قصير"],
          ].map(([key, label]) => (
            <button
              key={key}
              className={`exams-chip ${filterType === key ? "exams-chip-selected" : ""}`}
              onClick={() => setFilterType(key)}
            >
              {label}
            </button>
          ))}

          <span className="exams-filter-divider" />

          <button
            className={`exams-chip ${filterSubject === "all" ? "exams-chip-selected" : ""}`}
            onClick={() => setFilterSubject("all")}
          >
            كل المواد
          </button>

          {uniqueSubjects.map((subject) => (
            <button
              key={subject.key}
              className={`exams-chip ${filterSubject === subject.key ? "exams-chip-selected" : ""}`}
              onClick={() => setFilterSubject(subject.key)}
            >
              {subject.name}
            </button>
          ))}
        </div>

        <button
          className="exams-btn exams-btn-primary exams-toolbar-start"
          onClick={() => navigate("/exams/new")}
        >
          <Plus size={16} />
          ابدأ اختبار جديد
        </button>
      </div>

      {pendingDeleteExam && (
        <div className="exams-delete-confirm">
          <div>
            <strong className="exams-delete-title">
              تأكيد حذف نتيجة الامتحان
            </strong>
            <p className="exams-delete-text">
              هل أنت متأكد من حذف نتيجة الامتحان لـ
              <strong> {pendingDeleteExam.subjectName} </strong> بتاريخ
              <strong> {pendingDeleteExam.date} </strong>؟
              هذه العملية لا يمكن التراجع عنها.
            </p>
            {deleteError && (
              <p className="exams-delete-error">
                {deleteError}
              </p>
            )}
          </div>

          <div className="exams-delete-actions">
            <button
              className="exams-btn exams-btn-outline exams-confirm-btn"
              onClick={() => setPendingDeleteExam(null)}
            >
              إلغاء
            </button>
            <button
              className="exams-btn exams-btn-danger exams-confirm-btn"
              disabled={deletingResultId === pendingDeleteExam.examResultId}
              onClick={() => handleDeleteResult(pendingDeleteExam.examResultId)}
            >
              {deletingResultId === pendingDeleteExam.examResultId ? "جاري الحذف..." : "حذف نهائي"}
            </button>
          </div>
        </div>
      )}

      {loading ? (
        <div className="exams-card exams-state-card">
          <Loader2
            className="animate-spin exams-state-icon"
          />

          <h3 className="exams-state-title">
            جاري تحميل الامتحانات
          </h3>

          <p className="exams-state-text">يرجى الانتظار قليلاً...</p>
        </div>
      ) : pageError ? (
        <div className="exams-card exams-state-card exams-state-error">
          <FileText size={48} className="exams-state-icon" />

          <h3 className="exams-state-title">
            حدثت مشكلة
          </h3>

          <p>{pageError}</p>
        </div>
      ) : showNoRecords ? (
        <div className="exams-card exams-state-card">
          <FileText
            size={48}
            className="exams-state-icon"
          />

          <h3 className="exams-state-title">
            لا توجد امتحانات
          </h3>

          <p className="exams-empty-text">
            لم يتم العثور على امتحانات بهذا الفلتر. جرب فلتر آخر أو ابدأ اختبار جديد.
          </p>

          <button className="exams-btn exams-btn-primary" onClick={() => navigate("/exams/new")}>
            <Plus size={16} />
            ابدأ اختبار جديد
          </button>
        </div>
      ) : (
        <motion.div className="exams-grid" initial={{ opacity: 0 }} animate={{ opacity: 1 }}>
          {filteredRecords.map((exam, index) => {
            const Icon = iconMap[exam.subject] || BookOpen;
            const color = colorMap[exam.subject] || "blue";
            const isShortExam = isShortType(exam.type);

            return (
              <motion.div
                key={exam.examResultId || `${exam.examId}-${index}`}
                className="exams-card exam-card"
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.06 }}
              >
                <div className="exam-card-header">
                  <div className={`rec-icon-wrap rec-icon-${color}`}>
                    <Icon size={20} />
                  </div>

                  <span
                    className={`exam-type-badge exam-type-${exam.type === "comprehensive" ? "full" : "quick"
                      }`}
                  >
                    {exam.typeName || (exam.type === "comprehensive" ? "شامل" : "قصير")}
                  </span>
                </div>

                <h3 className="rec-title">{exam.subjectName}</h3>

                <p className="exam-card-subtitle">
                  {exam.type === "comprehensive"
                    ? "امتحان شامل"
                    : isShortExam && exam.lessonTitle
                      ? `اختبار قصير — ${exam.lessonTitle}`
                      : "اختبار قصير"}
                </p>

                <div className="exam-meta">
                  <span>📋 {exam.total} سؤال</span>
                  <span>📅 {exam.date}</span>
                </div>

                <div className="exam-completed-section">
                  <div className="exam-score-badge">
                    <Award size={16} />
                    <span>النتيجة: {exam.percentage}٪</span>
                  </div>

                  <div className="exam-score-progress">
                    <div
                      className="exam-score-progress-fill"
                      style={{
                        width: `${Math.min(100, Math.max(0, exam.percentage))}%`,
                        background:
                          exam.percentage >= 80
                            ? "hsl(152, 70%, 45%)"
                            : exam.percentage >= 60
                              ? "hsl(38, 90%, 50%)"
                              : "hsl(0, 84%, 55%)",
                      }}
                    />
                  </div>
                </div>

                <div className="exam-card-actions">
                  <button
                    className="exams-btn exams-btn-outline exam-action-btn"
                    onClick={() =>
                      navigate(`/exams/take?resultId=${exam.examResultId}&mode=review`)
                    }
                  >
                    <Eye size={16} />
                    مراجعة الأخطاء والنتيجة
                  </button>

                  <button
                    className="exams-btn exams-btn-outline exam-action-btn exam-action-danger"
                    disabled={deletingResultId === exam.examResultId}
                    onClick={() => setPendingDeleteExam(exam)}
                  >
                    <Trash2 size={16} />
                    حذف النتيجة
                  </button>
                </div>
              </motion.div>
            );
          })}
        </motion.div>
      )}
    </SideBar>
  );
};

export default Exams;
