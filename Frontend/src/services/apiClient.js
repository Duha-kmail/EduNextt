import axios from "axios";
import { API_BASE_URL } from "@/config/api";

const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    "Content-Type": "application/json",
  },
});

apiClient.interceptors.request.use((config) => {
  const token = sessionStorage.getItem("token") || localStorage.getItem("token");

  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }

  return config;
});

export const getApiErrorMessage = (
  error,
  fallback = "تعذر تنفيذ الطلب. حاول مرة أخرى."
) => {
  return (
    error?.response?.data?.message ||
    error?.response?.data?.Message ||
    error?.message ||
    fallback
  );
};

export default apiClient;
