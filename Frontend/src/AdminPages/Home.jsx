import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  ArrowLeft,
  Atom,
  BarChart3,
  BookOpen,
  Bot,
  Calendar,
  ChevronDown,
  ClipboardCheck,
  Database,
  Facebook,
  Globe2,
  GraduationCap,
  Instagram,
  Layers,
  Lightbulb,
  LineChart,
  Mail,
  MapPin,
  Menu,
  Phone,
  Plus,
  School,
  Send,
  Sigma,
  Smartphone,
  Sparkles,
  Target,
  TrendingUp,
  UserPlus,
  UsersRound,
  X,
  Youtube,
} from 'lucide-react';
import '../AdminStyles/Home.css';
import GeneralChatbot from '../components/Public_Chatbot/GeneralChatbot.jsx';
import logo from '../assets/EDU.svg';
import heroImage from '../assets/lovable-home/hero.png';
import whyImage from '../assets/lovable-home/why.png';

const quickFeatures = [
  { label: 'مساعد ذكي لكل مادة', icon: Bot },
  { label: 'خطط دراسية ذكية', icon: Calendar },
  { label: 'تحليل الأداء', icon: LineChart },
  { label: 'اختبارات تجريبية', icon: ClipboardCheck },
  { label: 'توصيات مخصصة', icon: Sparkles },
];

const showcaseCards = [
  {
    title: 'الخطة الدراسية',
    text: 'جدول يومي يتكيّف مع مستواك ووقتك وأهدافك.',
    type: 'plan',
  },
  {
    title: 'المساعد الذكي',
    text: 'اسأل أي سؤال واحصل على شرح فوري ودقيق.',
    type: 'chat',
  },
  {
    title: 'لوحة التحكم',
    text: 'تابع تقدمك وأدائك في المواد والاختبارات بسهولة.',
    type: 'chart',
  },
];

const toolCards = [
  { title: 'مساعد ذكي لكل مادة', text: 'روبوت ذكي يجيب على أسئلتك ويشرحها فوراً 24/7.', icon: Bot, tone: 'teal' },
  { title: 'خطط دراسية ذكية', text: 'جداول تتكيّف مع وقتك وأهدافك ومستواك الدراسي.', icon: Calendar, tone: 'blue' },
  { title: 'توصيات مخصصة', text: 'محتوى ودروس مخصّصة بناءً على تحليل أدائك.', icon: Sparkles, tone: 'purple' },
  { title: 'اختبارات تجريبية', text: 'اختبارات على نسق الامتحان الوزاري مع تصحيح فوري.', icon: ClipboardCheck, tone: 'teal' },
  { title: 'تتبع التقدم', text: 'لوحة تحكم ذكية تعرض تطورك ونقاط قوتك وضعفك.', icon: TrendingUp, tone: 'blue' },
];

const whyItems = [
  { title: 'تعلم مخصص', icon: BookOpen },
  { title: 'توصيات ذكية', icon: Sparkles },
  { title: 'مساعد ذكي', icon: Bot },
  { title: 'متابعة التقدم', icon: TrendingUp },
  { title: 'تنظيم الوقت', icon: Calendar },
  { title: 'تحسين الأداء الأكاديمي', icon: GraduationCap },
];

const subjects = [
  {
    id: 'arabic',
    name: 'اللغة العربية',
    description: 'الأدب، القواعد، التعبير والبلاغة.',
    longDescription:
      'مادة أساسية تساعدك على إتقان النصوص والقواعد والبلاغة والتعبير، مع تدريبات مناسبة لنمط أسئلة التوجيهي.',
    icon: BookOpen,
    tone: 'teal',
  },
  {
    id: 'english',
    name: 'اللغة الإنجليزية',
    description: 'القواعد والتراكم، الأدب والاستيعاب القرائي.',
    longDescription:
      'مراجعة مركزة للقواعد والمفردات والاستيعاب القرائي والنصوص، مع شرح مبسط وتمارين تقيس تقدمك.',
    icon: Globe2,
    tone: 'blue',
  },
  {
    id: 'math',
    name: 'الرياضيات',
    description: 'التفاضل والتكامل، الجبر والإحصاء.',
    longDescription:
      'مسار تدريبي للرياضيات يغطي التفاضل والتكامل والجبر والإحصاء، مع تحليل للأخطاء وخطة مراجعة ذكية.',
    icon: Sigma,
    tone: 'purple',
  },
  {
    id: 'physics',
    name: 'الفيزياء',
    description: 'الميكانيكا، الكهرومغناطيسية والفيزياء الحديثة.',
    longDescription:
      'شرح مفاهيم الفيزياء خطوة بخطوة، من الميكانيكا إلى الكهرباء والفيزياء الحديثة، مع تطبيقات وأسئلة تدريبية.',
    icon: Atom,
    tone: 'teal',
  },
];

const steps = [
  { title: 'إنشاء حساب', text: 'سجل حساباً مجانياً وابدأ رحلتك الآن.', icon: UserPlus, tone: 'teal' },
  { title: 'اختر موادك', text: 'اختر المواد التي تريد دراستها حسب مستواك وأهدافك.', icon: Layers, tone: 'blue' },
  { title: 'ادرس مع المساعد الذكي', text: 'احصل على شرح وحلول فورية مخصصة لكل مادة.', icon: Bot, tone: 'purple' },
  { title: 'تابع تقدمك', text: 'راقب أداءك وحقق أهدافك بخطوات ثابتة.', icon: TrendingUp, tone: 'teal' },
];

const upcoming = [
  { title: 'تطبيق الهاتف', text: 'تابع دراستك في أي وقت ومن أي مكان.', icon: Smartphone },
  { title: 'مجتمع تعليمي متكامل', text: 'مجموعات دراسة، نقاشات، وتحديات بين الطلاب.', icon: UsersRound },
  { title: 'بنك أسئلة أكبر', text: 'آلاف الأسئلة الجديدة مع تحديثات مستمرة.', icon: Database },
  { title: 'توصيات أكثر ذكاءً', text: 'تحليل أعمق للنقاط والفرص لتعلّم أكثر دقة.', icon: Lightbulb },
  { title: 'لوحة للمعلمين', text: 'متابعة أداء الطلاب وإدارة المهام بسهولة.', icon: School },
  { title: 'دعم مواد إضافية', text: 'توسيع تغطية المواد والفروع المستقبلية.', icon: Plus },
];

const faqs = [
  {
    question: 'ما هي منصة EduNext؟',
    answer: 'EduNext منصة تعليمية ذكية مصممة لطلاب التوجيهي، تقدم خططاً دراسية مخصصة ومساعداً ذكياً لكل مادة وتحليلات أداء دقيقة.',
  },
  {
    question: 'هل المنصة مجانية؟',
    answer: 'يمكنك البدء مجاناً وتجربة أدوات المنصة الأساسية، ثم اختيار الميزات المناسبة لاحتياجاتك لاحقاً.',
  },
  {
    question: 'كيف يعمل الذكاء الاصطناعي في المنصة؟',
    answer: 'يحلل أداءك وأهدافك ونمط دراستك، ثم يقترح خطة وتوصيات وأسئلة تدريبية تساعدك على تحسين نتائجك.',
  },
  {
    question: 'هل يمكنني استخدام المنصة على الهاتف؟',
    answer: 'نعم، التصميم متجاوب ويعمل بسلاسة على الهاتف والتابلت والكمبيوتر.',
  },
];

function BrowserMockup({ type }) {
  return (
    <div className={`mock-window ${type}`}>
      <div className="window-dots">
        <span />
        <span />
        <span />
      </div>
      {type === 'chart' && (
        <div className="chart-bars" aria-hidden="true">
          {[44, 70, 56, 82, 31, 64, 39].map((height, index) => <i key={index} style={{ height: `${height}%` }} />)}
        </div>
      )}
      {type === 'chat' && (
        <div className="chat-lines" aria-hidden="true">
          <i />
          <i />
          <i />
          <i />
          <i />
        </div>
      )}
      {type === 'plan' && (
        <div className="plan-board" aria-hidden="true">
          <i />
          <i />
          <i />
          <b />
          <b />
          <b />
          <b />
        </div>
      )}
    </div>
  );
}

export default function Home() {
  const navigate = useNavigate();
  const [mobileOpen, setMobileOpen] = useState(false);
  const [openFaq, setOpenFaq] = useState(0);
  const [activeSubject, setActiveSubject] = useState(null);

  const handleLogin = () => navigate('/login');
  const handleSignup = () => navigate('/register');

  return (
    <div className="edn-home" dir="rtl">
      <header className="edn-header">
        <div className="edn-container edn-nav">
          <button className="edn-brand" type="button" onClick={() => navigate('/')}>
            <img className="edn-brand-logo" src={logo} alt="EduNext" />
            <strong>EduNext</strong>
          </button>

          <nav className={`edn-links ${mobileOpen ? 'open' : ''}`}>
            <a href="#hero" onClick={() => setMobileOpen(false)}>الرئيسية</a>
            <a href="#subjects" onClick={() => setMobileOpen(false)}>المواد الدراسية</a>
            <a href="#faq" onClick={() => setMobileOpen(false)}>الأسئلة الشائعة</a>
            <a href="/contact" onClick={() => setMobileOpen(false)}>تواصل معنا</a>
          </nav>

          <div className="edn-actions">
            <button className="btn btn-ghost" type="button" onClick={handleLogin}>تسجيل دخول</button>
            <button className="btn btn-primary" type="button" onClick={handleSignup}>ابدأ مجاناً</button>
          </div>

          <button className="menu-btn" type="button" onClick={() => setMobileOpen((value) => !value)} aria-label="فتح القائمة">
            {mobileOpen ? <X size={22} /> : <Menu size={22} />}
          </button>
        </div>
      </header>

      <main>
        <section className="hero-section grid-bg" id="hero">
          <div className="edn-container hero-grid">
            <div className="hero-copy">
              <span className="pill">منصة التوجيهي الذكية</span>
              <h1>تعلّم بذكاء،<br /><mark>وتفوّق بثقة</mark></h1>
              <p>
                EduNext هي منصة تعليمية ذكية لطلاب التوجيهي تقدم خططاً دراسية مخصصة،
                مساعداً ذكياً لكل مادة، وتحليلات أداء تساعدك على تحقيق أفضل النتائج.
              </p>
              <div className="hero-buttons">
                <button className="btn btn-primary" type="button" onClick={handleSignup}>ابدأ مجاناً</button>
                <button className="btn btn-ghost" type="button" onClick={handleLogin}>تسجيل الدخول</button>
              </div>
            </div>

            <div className="hero-visual">
              <div className="hero-image-panel">
                <img src={heroImage} alt="طالب يستخدم منصة EduNext" />
              </div>
              <div className="float-card progress">
                <span>معدل التقدم</span>
                <strong>82%</strong>
                <LineChart size={18} />
              </div>
              <div className="float-card recommend">
                <span>توصية ذكية</span>
                <strong>راجع الفيزياء لمدة 30 دقيقة</strong>
                <Bot size={18} />
              </div>
              <div className="float-card target">
                <span>الأهداف</span>
                <strong>3 أهداف مكتملة هذا الأسبوع</strong>
                <Target size={18} />
              </div>
              <div className="float-card exam">
                <span>اختبار مكتمل</span>
                <strong>رياضيات — 9/10</strong>
                <ClipboardCheck size={18} />
              </div>
            </div>
          </div>

          <div className="edn-container">
            <div className="quick-strip">
              {quickFeatures.map((item) => (
                <div key={item.label}>
                  <item.icon size={18} />
                  <span>{item.label}</span>
                </div>
              ))}
            </div>
          </div>
        </section>

        <section className="showcase-section grid-bg">
          <div className="edn-container">
            <div className="section-title">
              <span className="pill">تجربة واقعية</span>
              <h2>شاهد EduNext أثناء العمل</h2>
              <p>اكتشف كيف تساعدك المنصة على تنظيم الدراسة وتحليل الأداء والتعلّم بذكاء.</p>
            </div>
            <div className="showcase-grid">
              {showcaseCards.map((card) => (
                <article className="showcase-card" key={card.title}>
                  <BrowserMockup type={card.type} />
                  <h3>{card.title}</h3>
                  <p>{card.text}</p>
                </article>
              ))}
            </div>
          </div>
        </section>

        <section className="tools-section" id="tools">
          <div className="edn-container">
            <div className="section-title">
              <span className="eyebrow">أدوات EduNext</span>
              <h2>كل ما تحتاجه للتعلّم بذكاء</h2>
              <p>أدوات متكاملة تساعدك على التعلم بتركيز وتحقق أفضل النتائج.</p>
            </div>
            <div className="tools-grid">
              {toolCards.map((tool) => (
                <article className={`tool-card ${tool.tone}`} key={tool.title}>
                  <div className="icon-box"><tool.icon size={26} /></div>
                  <h3>{tool.title}</h3>
                  <p>{tool.text}</p>
                </article>
              ))}
            </div>
          </div>
        </section>

        <section className="why-section grid-bg">
          <div className="edn-container why-grid">
            <div className="why-copy">
              <span className="eyebrow">لماذا EduNext</span>
              <h2>التوجيهي صعب بما فيه الكفاية،<br />الدراسة لا يجب أن تكون كذلك.</h2>
              <div className="why-list">
                {whyItems.map((item) => (
                  <div key={item.title}>
                    <item.icon size={18} />
                    <span>{item.title}</span>
                  </div>
                ))}
              </div>
            </div>
            <div className="why-image">
              <img src={whyImage} alt="" />
            </div>
          </div>
        </section>

        <section className="subjects-section" id="subjects">
          <div className="edn-container">
            <div className="section-title">
              <span className="eyebrow">المواد</span>
              <h2>استكشف موادك الدراسية</h2>
              <p>اختر المادة وابدأ رحلتك التعليمية.</p>
            </div>
            <div className="subjects-grid">
              {subjects.map((subject) => (
                <article className={`subject-card ${subject.tone}`} key={subject.id}>
                  <div className="icon-box"><subject.icon size={30} /></div>
                  <h3>{subject.name}</h3>
                  <p>{subject.description}</p>
                  <button type="button" onClick={() => setActiveSubject(subject)}>
                    استكشف المادة <ArrowLeft size={16} />
                  </button>
                </article>
              ))}
            </div>
            <div className="subjects-signup">
              <div>
                <span>مواد أكثر بانتظارك</span>
                <h3>لتصفح باقي المواد، سجل حسابك وابدأ رحلتك معنا</h3>
                <p>افتح كل المواد والخطط والاختبارات من حسابك الشخصي.</p>
              </div>
              <button className="btn btn-primary" type="button" onClick={handleSignup}>
                سجل الآن <ArrowLeft size={18} />
              </button>
            </div>
          </div>
        </section>

        <section className="steps-section grid-bg">
          <div className="edn-container">
            <div className="section-title">
              <span className="pill">الخطوات</span>
              <h2>كيف تبدأ رحلتك مع EduNext</h2>
            </div>
            <div className="steps-line">
              {steps.map((step, index) => (
                <article className={`step-item ${step.tone}`} key={step.title}>
                  <div className="step-icon">
                    <step.icon size={32} />
                    <span>{index + 1}</span>
                  </div>
                  <h3>{step.title}</h3>
                  <p>{step.text}</p>
                </article>
              ))}
            </div>
          </div>
        </section>

        <section className="upcoming-section grid-bg-soft">
          <div className="edn-container">
            <div className="section-title">
              <span className="pill">يتم العمل عليها</span>
              <h2>ميزات قادمة قريباً</h2>
              <p>نعمل باستمرار على تطوير المنصة لتقديم أفضل تجربة تعليمية ممكنة.</p>
            </div>
            <div className="upcoming-grid">
              {upcoming.map((item) => (
                <article className="upcoming-card" key={item.title}>
                  <div><item.icon size={22} /></div>
                  <h3>{item.title}</h3>
                  <p>{item.text}</p>
                </article>
              ))}
            </div>
          </div>
        </section>

        <section className="faq-section grid-bg" id="faq">
          <div className="edn-container">
            <div className="section-title">
              <span className="eyebrow">FAQ</span>
              <h2>الأسئلة الشائعة</h2>
            </div>
            <div className="faq-list">
              {faqs.map((faq, index) => (
                <article className={`faq-item ${openFaq === index ? 'open' : ''}`} key={faq.question}>
                  <button type="button" onClick={() => setOpenFaq(openFaq === index ? null : index)}>
                    <span>{faq.question}</span>
                    <ChevronDown size={20} />
                  </button>
                  {openFaq === index && <p>{faq.answer}</p>}
                </article>
              ))}
            </div>
          </div>
        </section>

      </main>

      <footer className="edn-footer">
        <div className="edn-container footer-grid">
          <div>
            <div className="edn-brand footer-brand">
              <img className="edn-brand-logo" src={logo} alt="EduNext" />
              <strong>EduNext</strong>
            </div>
            <p>منصة تعليمية ذكية لطلاب التوجيهي.</p>
            <div className="socials">
              <Instagram size={18} />
              <Send size={18} />
              <Youtube size={18} />
              <Facebook size={18} />
            </div>
          </div>
          <div>
            <h3>المواد الدراسية</h3>
            <a href="#subjects">اللغة العربية</a>
            <a href="#subjects">اللغة الإنجليزية</a>
            <a href="#subjects">الرياضيات</a>
            <a href="#subjects">الفيزياء</a>
          </div>
          <div>
            <h3>المنصة</h3>
            <button type="button" onClick={handleLogin}>تسجيل دخول</button>
            <button type="button" onClick={handleSignup}>إنشاء حساب</button>
            <a href="#tools">أدوات المنصة</a>
            <a href="#faq">الأسئلة الشائعة</a>
          </div>
          <div>
            <h3>تواصل معنا</h3>
            <p><Mail size={16} /> edunext.contact@gmail.com</p>
            <p><Phone size={16} /> 3522 895 59 970+</p>
            <p><MapPin size={16} /> جنين، فلسطين</p>
          </div>
        </div>
        <div className="edn-container copyright">جميع الحقوق محفوظة © 2026 EduNext</div>
      </footer>

      {activeSubject && (
        <div className="subject-modal-overlay" onClick={() => setActiveSubject(null)} role="presentation">
          <div className="subject-modal" onClick={(event) => event.stopPropagation()} role="dialog" aria-modal="true">
            <button className="modal-close" type="button" onClick={() => setActiveSubject(null)} aria-label="إغلاق"><X size={18} /></button>
            <div className={`icon-box ${activeSubject.tone}`}><activeSubject.icon size={32} /></div>
            <h3>{activeSubject.name}</h3>
            <p>{activeSubject.longDescription}</p>
            <div className="modal-actions">
              <button className="btn btn-primary" type="button" onClick={handleLogin}>ابدأ التعلم</button>
              <button className="btn btn-ghost" type="button" onClick={() => setActiveSubject(null)}>إغلاق</button>
            </div>
          </div>
        </div>
      )}
      <GeneralChatbot compact />
    </div>
  );
}
