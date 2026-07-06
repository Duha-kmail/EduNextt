import React, { useEffect, useState } from "react";
import "./public/auth/password-reset/AuthFlow.css";
import { motion as Motion } from "framer-motion";
import { ArrowLeft, Lock } from "lucide-react";
import { useNavigate } from "react-router-dom";
import PublicNavbar from "../components/public-navbar/PublicNavbar.jsx";
import apiClient, { getApiErrorMessage } from "@/services/apiClient";

async function postJson(path, body) {
  try {
    const response = await apiClient.post(path, body);
    return response.data;
  } catch (error) {
    throw new Error(
      getApiErrorMessage(error, "تعذر تنفيذ الطلب. حاول مرة أخرى.")
    );
  }
}

const OTP_EXPIRY_MS = 60 * 1000;

export default function OtpVerificationPage() {
  const [otp, setOtp] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [email, setEmail] = useState("");
  const [error, setError] = useState("");
  const [secondsLeft, setSecondsLeft] = useState(60);
  const [isResending, setIsResending] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    const storedEmail = sessionStorage.getItem("resetEmail");

    if (!storedEmail) {
      navigate("/forgot-password", { replace: true });
      return;
    }

    const expiresAt = Number(sessionStorage.getItem("resetOtpExpiresAt"));

    setEmail(storedEmail);
    setSecondsLeft(Math.max(0, Math.ceil((expiresAt - Date.now()) / 1000)));
  }, [navigate]);

  useEffect(() => {
    const timerId = window.setInterval(() => {
      const expiresAt = Number(sessionStorage.getItem("resetOtpExpiresAt"));
      setSecondsLeft(Math.max(0, Math.ceil((expiresAt - Date.now()) / 1000)));
    }, 1000);

    return () => window.clearInterval(timerId);
  }, []);

  const formatTimer = (seconds) => {
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = seconds % 60;

    return `${minutes}:${String(remainingSeconds).padStart(2, "0")}`;
  };

  const handleOtpChange = (event) => {
    const value = event.target.value;

    if (/^\d{0,6}$/.test(value)) {
      setOtp(value);
      setError("");
    }
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    setError("");

    if (otp.length !== 6) {
      setError("يرجى إدخال رمز التحقق كاملًا من 6 أرقام.");
      return;
    }

    if (secondsLeft <= 0) {
      setError("رمز التحقق انتهت صلاحيته. أعد إرسال رمز جديد.");
      return;
    }

    try {
      setIsSubmitting(true);

      await postJson("/api/auth/verify-otp", { email, otp });

      sessionStorage.setItem("otpVerified", "true");
      navigate("/reset-password");
    } catch (requestError) {
      setError(requestError.message || "رمز التحقق غير صحيح أو منتهي الصلاحية.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const resendOtp = async () => {
    if (!email || isResending || secondsLeft > 0) {
      return;
    }

    setError("");
    setIsResending(true);

    try {
      await postJson("/api/auth/forgot-password", { email });
      sessionStorage.setItem("resetOtpExpiresAt", String(Date.now() + OTP_EXPIRY_MS));
      sessionStorage.removeItem("otpVerified");
      setOtp("");
      setSecondsLeft(60);
    } catch (requestError) {
      setError(requestError.message || "تعذر إعادة إرسال رمز التحقق.");
    } finally {
      setIsResending(false);
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
              <h2 className="auth-flow-form-title">التحقق من الرمز</h2>
              <p className="auth-flow-form-subtitle">
                أدخل الرمز الذي تم إرساله إلى {email}
              </p>
            </Motion.div>

            <form onSubmit={handleSubmit} className="space-y-5">
              {error && <p className="auth-flow-message auth-flow-error">{error}</p>}

              <Motion.div
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: 0.3, duration: 0.5 }}
                className="auth-flow-form-group"
              >
                <label className="auth-flow-form-label" htmlFor="otp">
                  رمز التحقق
                </label>
                <div className="auth-flow-input-wrapper">
                  <span className="auth-flow-input-icon">
                    <Lock size={20} />
                  </span>
                  <input
                    id="otp"
                    type="text"
                    inputMode="numeric"
                    value={otp}
                    onChange={handleOtpChange}
                    className="auth-flow-input auth-flow-input-otp"
                    placeholder="000000"
                    maxLength="6"
                    autoComplete="one-time-code"
                    required
                  />
                </div>
              </Motion.div>

              <div className="otp-info">
                {secondsLeft > 0 ? (
                  <p className="info-text">
                    الرمز صالح لمدة دقيقة واحدة: {formatTimer(secondsLeft)}
                  </p>
                ) : (
                  <button
                    type="button"
                    className="auth-flow-resend-btn"
                    onClick={resendOtp}
                    disabled={isResending}
                  >
                    {isResending ? "جاري إعادة الإرسال..." : "إعادة إرسال الرمز"}
                  </button>
                )}
              </div>

              <Motion.button
                whileHover={!isSubmitting && secondsLeft > 0 && otp.length === 6 ? { scale: 1.01 } : undefined}
                whileTap={!isSubmitting && secondsLeft > 0 && otp.length === 6 ? { scale: 0.99 } : undefined}
                type="submit"
                className="auth-flow-submit-btn"
                disabled={isSubmitting || secondsLeft <= 0 || otp.length !== 6}
              >
                {isSubmitting ? "جاري التحقق..." : "التحقق من الرمز"}
              </Motion.button>
            </form>

            <div className="auth-flow-footer-link-section">
              <button type="button" className="auth-flow-footer-link" onClick={() => navigate("/forgot-password")}>
                <ArrowLeft size={14} className="rotate-180 ml-1" />
                تغيير البريد
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
                <h3 className="auth-flow-hero-title">تحقق من بريدك</h3>
                <p className="auth-flow-hero-description">
                  استخدم آخر رمز وصل إلى بريدك الإلكتروني.
                </p>
              </div>
            </div>
          </div>
        </Motion.div>
      </main>
    </div>
  );
}
