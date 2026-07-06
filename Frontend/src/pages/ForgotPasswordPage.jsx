import React, { useState } from "react";
import "./public/auth/password-reset/AuthFlow.css";
import { motion as Motion } from "framer-motion";
import { ArrowLeft, Mail } from "lucide-react";
import { useNavigate } from "react-router-dom";
import PublicNavbar from "../components/public-navbar/PublicNavbar.jsx";
import apiClient, { getApiErrorMessage } from "@/services/apiClient";

async function postJson(path, body) {
  try {
    const response = await apiClient.post(path, body);
    return response.data;
  } catch (error) {
    throw new Error(
      getApiErrorMessage(
        error,
        "تعذر إرسال رمز التحقق. تأكد من إعدادات البريد الإلكتروني ثم حاول مرة أخرى."
      )
    );
  }
}

const OTP_EXPIRY_MS = 60 * 1000;

export default function ForgotPasswordPage() {
  const [email, setEmail] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleSubmit = async (event) => {
    event.preventDefault();
    setMessage("");
    setError("");

    try {
      setIsSubmitting(true);

      await postJson("/api/auth/forgot-password", { email: email.trim() });

      sessionStorage.setItem("resetEmail", email.trim());
      sessionStorage.setItem("resetOtpExpiresAt", String(Date.now() + OTP_EXPIRY_MS));
      sessionStorage.removeItem("otpVerified");

      setMessage("تم إرسال رمز التحقق إلى بريدك الإلكتروني.");
      navigate("/otp-verification");
    } catch (requestError) {
      setError(requestError.message || "حدث خطأ. يرجى المحاولة لاحقا.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="layout-wrapper auth-flow-page" dir="rtl">
      <PublicNavbar compact />
      <main className="auth-flow-main">
        <Motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6, ease: "easeOut" }}
          className="auth-flow-card"
        >
          <div className="auth-flow-form-section">
            <Motion.div
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.2, duration: 0.5 }}
              className="auth-flow-form-header"
            >
              <h2 className="auth-flow-form-title">استعادة كلمة المرور</h2>
              <p className="auth-flow-form-subtitle">أدخل بريدك الإلكتروني لإرسال رمز تحقق آمن.</p>
            </Motion.div>

            <form onSubmit={handleSubmit} className="space-y-5">
              {error && <p className="auth-flow-message auth-flow-error">{error}</p>}
              {message && <p className="auth-flow-message auth-flow-success">{message}</p>}

              <Motion.div
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.3, duration: 0.5 }}
                className="auth-flow-form-group"
              >
                <label className="auth-flow-form-label" htmlFor="email">
                  البريد الإلكتروني
                </label>
                <div className="auth-flow-input-wrapper">
                  <span className="auth-flow-input-icon">
                    <Mail size={20} />
                  </span>
                  <input
                    id="email"
                    type="email"
                    value={email}
                    onChange={(event) => setEmail(event.target.value)}
                    className="auth-flow-input auth-flow-input-email"
                    placeholder="example@gmail.com"
                    autoComplete="email"
                    required
                  />
                </div>
              </Motion.div>

              <Motion.button
                whileHover={!isSubmitting ? { scale: 1.01 } : undefined}
                whileTap={!isSubmitting ? { scale: 0.99 } : undefined}
                type="submit"
                className="auth-flow-submit-btn"
                disabled={isSubmitting}
              >
                {isSubmitting ? "جاري الإرسال..." : "إرسال رمز التحقق"}
              </Motion.button>
            </form>

            <div className="auth-flow-footer-link-section">
              <button type="button" className="auth-flow-footer-link" onClick={() => navigate("/login")}>
                <ArrowLeft size={14} className="rotate-180 ml-1" />
                العودة إلى تسجيل الدخول
              </button>
            </div>
          </div>

          <div className="auth-flow-visual-section">
            <div className="bg-blur-1"></div>
            <div className="bg-blur-2"></div>
            <div className="auth-flow-visual-content">
              <Motion.div
                initial={{ scale: 0.8, opacity: 0 }}
                animate={{ scale: 1, opacity: 1 }}
                transition={{ delay: 0.4, type: "spring", stiffness: 100 }}
                className="auth-flow-robot-image-wrapper"
              >
                <div className="auth-flow-robot-image"></div>
              </Motion.div>
              <div className="hero-text">
                <h3 className="auth-flow-hero-title">استعد الوصول إلى حسابك</h3>
                <p className="auth-flow-hero-description">سنرسل رمز تحقق صالحا لمدة دقيقة واحدة.</p>
              </div>
            </div>
          </div>
        </Motion.div>
      </main>
    </div>
  );
}
