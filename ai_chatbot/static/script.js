let subject = "math";
let attachedImage = null;

const API_BASE =
  window.location.protocol === "file:" ? "http://127.0.0.1:5001" : "";

const chatBox = document.getElementById("chat-box");
const form = document.getElementById("chat-form");
const input = document.getElementById("msg");
const title = document.getElementById("title");
const imageInput = document.getElementById("image-input");
const imagePreview = document.getElementById("image-preview");
const previewImg = document.getElementById("preview-img");
const removeImage = document.getElementById("remove-image");

document.querySelectorAll(".subject").forEach((button) => {
  button.addEventListener("click", () => {
    subject = button.dataset.subject;
    document.querySelectorAll(".subject").forEach((item) => item.classList.remove("active"));
    button.classList.add("active");
    title.innerText = subject === "math" ? "Chatbot الرياضيات" : "Chatbot اللغة الإنجليزية";
  });
});

imageInput.addEventListener("change", () => {
  const file = imageInput.files && imageInput.files[0];
  if (!file) return;

  if (!file.type.startsWith("image/")) {
    addMessage("الملف المرفق يجب أن يكون صورة.", "bot");
    imageInput.value = "";
    return;
  }

  if (file.size > 8 * 1024 * 1024) {
    addMessage("حجم الصورة كبير. اختر صورة أصغر من 8MB.", "bot");
    imageInput.value = "";
    return;
  }

  const reader = new FileReader();
  reader.onload = () => {
    attachedImage = {
      data: reader.result,
      mimeType: file.type,
      name: file.name,
    };
    previewImg.src = reader.result;
    imagePreview.hidden = false;
  };
  reader.readAsDataURL(file);
});

removeImage.addEventListener("click", () => {
  clearImage();
});

function clearImage() {
  attachedImage = null;
  imageInput.value = "";
  previewImg.removeAttribute("src");
  imagePreview.hidden = true;
}

function addMessage(text, type, imageSrc = null) {
  const wrapper = document.createElement("div");
  wrapper.className = `msg ${type}`;

  const bubble = document.createElement("div");
  bubble.className = "bubble";

  if (imageSrc) {
    const image = document.createElement("img");
    image.className = "message-image";
    image.src = imageSrc;
    image.alt = "صورة مرفقة";
    bubble.appendChild(image);
  }

  if (text) {
    const content = document.createElement("div");
    content.innerText = text;
    bubble.appendChild(content);
  }

  if (subject === "math" && type === "bot") {
    bubble.classList.add("math-answer");
  }

  wrapper.appendChild(bubble);
  chatBox.appendChild(wrapper);
  chatBox.scrollTop = chatBox.scrollHeight;

  return wrapper;
}

form.addEventListener("submit", async (event) => {
  event.preventDefault();

  const text = input.value.trim();
  if (!text && !attachedImage) return;

  const imageToSend = attachedImage;
  addMessage(text || "حلل الصورة المرفقة", "user", imageToSend?.data || null);
  input.value = "";
  clearImage();

  const loading = addMessage("جاري التفكير...", "bot");

  try {
    const response = await fetch(`${API_BASE}/chat`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        message: text,
        subject,
        image_data: imageToSend?.data || null,
        image_mime_type: imageToSend?.mimeType || null,
      }),
    });

    if (!response.ok) {
      throw new Error(`Server returned ${response.status}`);
    }

    const data = await response.json();
    loading.remove();
    addMessage(data.reply || "لم يصل رد من الخادم.", "bot");
  } catch (error) {
    loading.remove();
    addMessage("تعذر الاتصال بالخادم. تأكد أن السيرفر يعمل على http://127.0.0.1:5001", "bot");
  }
});
