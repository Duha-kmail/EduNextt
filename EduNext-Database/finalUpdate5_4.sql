--
-- PostgreSQL database cluster dump
--

-- Started on 2026-04-05 01:00:20

\restrict YveXUBiZVCYyEM7RSzFfr1HG9dLT47MrRwpODSaykJIBsvakobpDa8BIvhPc6Q4

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:BTB/tThgtX8+9h8mzJBRkA==$t4b5J1eGrZX5hV+UenrqaMQBtOnFkuDNltxAMzAM4Tw=:xwd7p57KPy+4T7Iv9ujStA0U1NYY6t0U7bhG5n8nT8c=';

--
-- User Configurations
--








\unrestrict YveXUBiZVCYyEM7RSzFfr1HG9dLT47MrRwpODSaykJIBsvakobpDa8BIvhPc6Q4

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict EKuqSvXQHDzkUxm6WfiIzyMKPPKJEDhxcK3EsHFaw6r61wr8zUzkCg3BGVg5Yru

-- Dumped from database version 18.2
-- Dumped by pg_dump version 18.2

-- Started on 2026-04-05 01:00:20

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-04-05 01:00:20

--
-- PostgreSQL database dump complete
--

\unrestrict EKuqSvXQHDzkUxm6WfiIzyMKPPKJEDhxcK3EsHFaw6r61wr8zUzkCg3BGVg5Yru

--
-- Database "EduNext_db" dump
--

--
-- PostgreSQL database dump
--

\restrict bxs1y3VnzZUjKTeZ7HwOiN3yYbGbHXbBAaz8igz5JdkHvOHxVf6IRezfL5FvzUJ

-- Dumped from database version 18.2
-- Dumped by pg_dump version 18.2

-- Started on 2026-04-05 01:00:20

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5302 (class 1262 OID 16388)
-- Name: EduNext_db; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "EduNext_db" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';


ALTER DATABASE "EduNext_db" OWNER TO postgres;

\unrestrict bxs1y3VnzZUjKTeZ7HwOiN3yYbGbHXbBAaz8igz5JdkHvOHxVf6IRezfL5FvzUJ
\connect "EduNext_db"
\restrict bxs1y3VnzZUjKTeZ7HwOiN3yYbGbHXbBAaz8igz5JdkHvOHxVf6IRezfL5FvzUJ

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 16389)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 5303 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 229 (class 1259 OID 16616)
-- Name: achievements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.achievements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(100),
    description text,
    condition_type character varying(50),
    condition_value integer
);


ALTER TABLE public.achievements OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16668)
-- Name: admin_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    admin_id uuid,
    action_type character varying(100),
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.admin_logs OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16585)
-- Name: ai_recommendations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ai_recommendations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    recommendation_text text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.ai_recommendations OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16565)
-- Name: exam_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exam_results (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    exam_id uuid,
    score integer,
    strength_points text,
    weakness_points text,
    level_message text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.exam_results OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16532)
-- Name: exams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exams (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    subject_id uuid,
    lesson_id uuid,
    type character varying(20) NOT NULL,
    CONSTRAINT exams_type_check CHECK (((type)::text = ANY ((ARRAY['comprehensive'::character varying, 'short'::character varying])::text[])))
);


ALTER TABLE public.exams OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16643)
-- Name: faq; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faq (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    question text NOT NULL,
    answer text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.faq OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16514)
-- Name: lesson_progress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesson_progress (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    lesson_id uuid,
    completed boolean DEFAULT false,
    completed_at timestamp without time zone
);


ALTER TABLE public.lesson_progress OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16499)
-- Name: lessons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lessons (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    subject_id uuid,
    title character varying(150) NOT NULL,
    video_url text,
    summary text,
    content text,
    order_number integer
);


ALTER TABLE public.lessons OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16550)
-- Name: questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    exam_id uuid,
    question_text text NOT NULL,
    option_a text,
    option_b text,
    option_c text,
    option_d text,
    correct_answer character varying(1),
    CONSTRAINT chk_correct_answer CHECK (((correct_answer)::text = ANY ((ARRAY['A'::character varying, 'B'::character varying, 'C'::character varying, 'D'::character varying])::text[])))
);


ALTER TABLE public.questions OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16655)
-- Name: site_content; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.site_content (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    content_key character varying(100) NOT NULL,
    content_value text NOT NULL
);


ALTER TABLE public.site_content OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 17051)
-- Name: student_preference_difficult_subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_preference_difficult_subjects (
    user_id uuid NOT NULL,
    subject_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.student_preference_difficult_subjects OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17036)
-- Name: student_preference_learning_methods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_preference_learning_methods (
    user_id uuid NOT NULL,
    method_code character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_student_preference_learning_methods_method CHECK (((method_code)::text = ANY ((ARRAY['videos'::character varying, 'reading'::character varying, 'practice'::character varying])::text[])))
);


ALTER TABLE public.student_preference_learning_methods OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 17009)
-- Name: student_preferences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_preferences (
    user_id uuid NOT NULL,
    branch_code character varying(20) NOT NULL,
    study_hours_code character varying(20) NOT NULL,
    goal_code character varying(30) NOT NULL,
    level_code character varying(20) NOT NULL,
    exam_experience_code character varying(20) NOT NULL,
    has_other_difficult_subject boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_student_preferences_branch CHECK (((branch_code)::text = ANY ((ARRAY['scientific'::character varying, 'literary'::character varying, 'industrial'::character varying, 'commercial'::character varying, 'sharia'::character varying])::text[]))),
    CONSTRAINT chk_student_preferences_exam CHECK (((exam_experience_code)::text = ANY ((ARRAY['many_times'::character varying, 'once'::character varying, 'never'::character varying])::text[]))),
    CONSTRAINT chk_student_preferences_goal CHECK (((goal_code)::text = ANY ((ARRAY['above_90'::character varying, 'from_80_to_90'::character varying, 'from_70_to_80'::character varying, 'pass_only'::character varying])::text[]))),
    CONSTRAINT chk_student_preferences_hours CHECK (((study_hours_code)::text = ANY ((ARRAY['lt_1'::character varying, 'h_1_2'::character varying, 'h_3_4'::character varying, 'gt_4'::character varying])::text[]))),
    CONSTRAINT chk_student_preferences_level CHECK (((level_code)::text = ANY ((ARRAY['beginner'::character varying, 'intermediate'::character varying, 'advanced'::character varying])::text[])))
);


ALTER TABLE public.student_preferences OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16774)
-- Name: student_profile_subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_profile_subjects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    student_profile_id uuid NOT NULL,
    subject_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.student_profile_subjects OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16755)
-- Name: student_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    stream character varying(50),
    current_grade character varying(30),
    exam_year integer,
    preferred_study_time character varying(50),
    preferred_study_place character varying(50),
    primary_goal character varying(100),
    is_onboarding_completed boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    learning_methods text[] DEFAULT ARRAY[]::text[] NOT NULL,
    exam_experience character varying(30),
    CONSTRAINT chk_student_profiles_exam_experience CHECK (((exam_experience IS NULL) OR ((exam_experience)::text = ANY ((ARRAY['many_times'::character varying, 'once'::character varying, 'never'::character varying])::text[])))),
    CONSTRAINT chk_student_profiles_exam_year CHECK (((exam_year IS NULL) OR ((exam_year >= 2024) AND (exam_year <= 2100))))
);


ALTER TABLE public.student_profiles OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16728)
-- Name: study_plan_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_plan_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    study_plan_id uuid NOT NULL,
    lesson_id uuid NOT NULL,
    order_number integer DEFAULT 1,
    is_completed boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.study_plan_items OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16600)
-- Name: study_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_plans (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    title character varying(150),
    description text,
    is_ai_generated boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    subject_id uuid,
    study_days text[] DEFAULT ARRAY[]::text[],
    daily_duration_minutes integer,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_study_plans_daily_duration CHECK (((daily_duration_minutes IS NULL) OR (daily_duration_minutes > 0)))
);


ALTER TABLE public.study_plans OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 17078)
-- Name: study_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    subject_id uuid,
    lesson_id uuid,
    started_at timestamp without time zone NOT NULL,
    ended_at timestamp without time zone,
    duration_minutes integer DEFAULT 0 NOT NULL,
    session_type character varying(20) DEFAULT 'study'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_study_sessions_duration_non_negative CHECK ((duration_minutes >= 0)),
    CONSTRAINT chk_study_sessions_type CHECK (((session_type)::text = ANY ((ARRAY['study'::character varying, 'exam'::character varying, 'review'::character varying])::text[])))
);


ALTER TABLE public.study_sessions OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16488)
-- Name: subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subjects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    stream character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.subjects OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16625)
-- Name: user_achievements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_achievements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    achievement_id uuid,
    earned_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_achievements OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16702)
-- Name: user_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_stats (
    user_id uuid NOT NULL,
    points integer DEFAULT 0 NOT NULL,
    level integer DEFAULT 1 NOT NULL,
    streak_days integer DEFAULT 0 NOT NULL,
    last_activity_date date,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_stats OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16470)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    full_name character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    password_hash text NOT NULL,
    role character varying(20) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    points integer DEFAULT 0,
    onboarding_completed boolean DEFAULT false NOT NULL,
    onboarding_completed_at timestamp without time zone,
    phone character varying(30),
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['student'::character varying, 'admin'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 5078 (class 2606 OID 16624)
-- Name: achievements achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- TOC entry 5090 (class 2606 OID 16677)
-- Name: admin_logs admin_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_logs
    ADD CONSTRAINT admin_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 5071 (class 2606 OID 16594)
-- Name: ai_recommendations ai_recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_recommendations
    ADD CONSTRAINT ai_recommendations_pkey PRIMARY KEY (id);


--
-- TOC entry 5067 (class 2606 OID 16574)
-- Name: exam_results exam_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_results
    ADD CONSTRAINT exam_results_pkey PRIMARY KEY (id);


--
-- TOC entry 5060 (class 2606 OID 16539)
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (id);


--
-- TOC entry 5084 (class 2606 OID 16654)
-- Name: faq faq_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faq
    ADD CONSTRAINT faq_pkey PRIMARY KEY (id);


--
-- TOC entry 5056 (class 2606 OID 16521)
-- Name: lesson_progress lesson_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_progress
    ADD CONSTRAINT lesson_progress_pkey PRIMARY KEY (id);


--
-- TOC entry 5052 (class 2606 OID 16508)
-- Name: lessons lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (id);


--
-- TOC entry 5065 (class 2606 OID 16559)
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- TOC entry 5086 (class 2606 OID 16667)
-- Name: site_content site_content_content_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_content
    ADD CONSTRAINT site_content_content_key_key UNIQUE (content_key);


--
-- TOC entry 5088 (class 2606 OID 16665)
-- Name: site_content site_content_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_content
    ADD CONSTRAINT site_content_pkey PRIMARY KEY (id);


--
-- TOC entry 5117 (class 2606 OID 17059)
-- Name: student_preference_difficult_subjects student_preference_difficult_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_preference_difficult_subjects
    ADD CONSTRAINT student_preference_difficult_subjects_pkey PRIMARY KEY (user_id, subject_id);


--
-- TOC entry 5113 (class 2606 OID 17045)
-- Name: student_preference_learning_methods student_preference_learning_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_preference_learning_methods
    ADD CONSTRAINT student_preference_learning_methods_pkey PRIMARY KEY (user_id, method_code);


--
-- TOC entry 5110 (class 2606 OID 17030)
-- Name: student_preferences student_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_preferences
    ADD CONSTRAINT student_preferences_pkey PRIMARY KEY (user_id);


--
-- TOC entry 5106 (class 2606 OID 16783)
-- Name: student_profile_subjects student_profile_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profile_subjects
    ADD CONSTRAINT student_profile_subjects_pkey PRIMARY KEY (id);


--
-- TOC entry 5100 (class 2606 OID 16766)
-- Name: student_profiles student_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 5102 (class 2606 OID 16768)
-- Name: student_profiles student_profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_user_id_key UNIQUE (user_id);


--
-- TOC entry 5097 (class 2606 OID 16739)
-- Name: study_plan_items study_plan_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_items
    ADD CONSTRAINT study_plan_items_pkey PRIMARY KEY (id);


--
-- TOC entry 5076 (class 2606 OID 16610)
-- Name: study_plans study_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plans
    ADD CONSTRAINT study_plans_pkey PRIMARY KEY (id);


--
-- TOC entry 5122 (class 2606 OID 17094)
-- Name: study_sessions study_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_sessions
    ADD CONSTRAINT study_sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 5048 (class 2606 OID 16498)
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- TOC entry 5058 (class 2606 OID 16685)
-- Name: lesson_progress uq_lesson_progress_user_lesson; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_progress
    ADD CONSTRAINT uq_lesson_progress_user_lesson UNIQUE (user_id, lesson_id);


--
-- TOC entry 5108 (class 2606 OID 16785)
-- Name: student_profile_subjects uq_student_profile_subject; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profile_subjects
    ADD CONSTRAINT uq_student_profile_subject UNIQUE (student_profile_id, subject_id);


--
-- TOC entry 5080 (class 2606 OID 16687)
-- Name: user_achievements uq_user_achievement; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT uq_user_achievement UNIQUE (user_id, achievement_id);


--
-- TOC entry 5082 (class 2606 OID 16632)
-- Name: user_achievements user_achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_pkey PRIMARY KEY (id);


--
-- TOC entry 5092 (class 2606 OID 16714)
-- Name: user_stats user_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_stats
    ADD CONSTRAINT user_stats_pkey PRIMARY KEY (user_id);


--
-- TOC entry 5046 (class 2606 OID 16485)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 5072 (class 1259 OID 16694)
-- Name: idx_ai_recommendations_user_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ai_recommendations_user_created ON public.ai_recommendations USING btree (user_id, created_at DESC);


--
-- TOC entry 5068 (class 1259 OID 16693)
-- Name: idx_exam_results_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_exam_results_user ON public.exam_results USING btree (user_id);


--
-- TOC entry 5069 (class 1259 OID 16692)
-- Name: idx_exam_results_user_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_exam_results_user_created ON public.exam_results USING btree (user_id, created_at DESC);


--
-- TOC entry 5061 (class 1259 OID 16698)
-- Name: idx_exams_lesson; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_exams_lesson ON public.exams USING btree (lesson_id);


--
-- TOC entry 5062 (class 1259 OID 16697)
-- Name: idx_exams_subject; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_exams_subject ON public.exams USING btree (subject_id);


--
-- TOC entry 5053 (class 1259 OID 16690)
-- Name: idx_lesson_progress_user_completed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lesson_progress_user_completed ON public.lesson_progress USING btree (user_id, completed);


--
-- TOC entry 5054 (class 1259 OID 16691)
-- Name: idx_lesson_progress_user_lesson; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lesson_progress_user_lesson ON public.lesson_progress USING btree (user_id, lesson_id);


--
-- TOC entry 5049 (class 1259 OID 16696)
-- Name: idx_lessons_subject; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lessons_subject ON public.lessons USING btree (subject_id);


--
-- TOC entry 5050 (class 1259 OID 16695)
-- Name: idx_lessons_subject_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lessons_subject_order ON public.lessons USING btree (subject_id, order_number);


--
-- TOC entry 5063 (class 1259 OID 16699)
-- Name: idx_questions_exam; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_questions_exam ON public.questions USING btree (exam_id);


--
-- TOC entry 5114 (class 1259 OID 17072)
-- Name: idx_student_preference_difficult_subjects_subject; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_student_preference_difficult_subjects_subject ON public.student_preference_difficult_subjects USING btree (subject_id);


--
-- TOC entry 5115 (class 1259 OID 17071)
-- Name: idx_student_preference_difficult_subjects_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_student_preference_difficult_subjects_user ON public.student_preference_difficult_subjects USING btree (user_id);


--
-- TOC entry 5111 (class 1259 OID 17070)
-- Name: idx_student_preference_learning_methods_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_student_preference_learning_methods_user ON public.student_preference_learning_methods USING btree (user_id);


--
-- TOC entry 5103 (class 1259 OID 16797)
-- Name: idx_student_profile_subjects_profile; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_student_profile_subjects_profile ON public.student_profile_subjects USING btree (student_profile_id);


--
-- TOC entry 5104 (class 1259 OID 16798)
-- Name: idx_student_profile_subjects_subject; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_student_profile_subjects_subject ON public.student_profile_subjects USING btree (subject_id);


--
-- TOC entry 5098 (class 1259 OID 16796)
-- Name: idx_student_profiles_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_student_profiles_user ON public.student_profiles USING btree (user_id);


--
-- TOC entry 5093 (class 1259 OID 16753)
-- Name: idx_study_plan_items_lesson; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_plan_items_lesson ON public.study_plan_items USING btree (lesson_id);


--
-- TOC entry 5094 (class 1259 OID 16752)
-- Name: idx_study_plan_items_plan; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_plan_items_plan ON public.study_plan_items USING btree (study_plan_id);


--
-- TOC entry 5095 (class 1259 OID 16754)
-- Name: idx_study_plan_items_plan_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_plan_items_plan_order ON public.study_plan_items USING btree (study_plan_id, order_number);


--
-- TOC entry 5073 (class 1259 OID 16751)
-- Name: idx_study_plans_subject; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_plans_subject ON public.study_plans USING btree (subject_id);


--
-- TOC entry 5074 (class 1259 OID 16750)
-- Name: idx_study_plans_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_plans_user ON public.study_plans USING btree (user_id);


--
-- TOC entry 5118 (class 1259 OID 17112)
-- Name: idx_study_sessions_subject; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_sessions_subject ON public.study_sessions USING btree (subject_id);


--
-- TOC entry 5119 (class 1259 OID 17110)
-- Name: idx_study_sessions_user_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_sessions_user_created ON public.study_sessions USING btree (user_id, created_at DESC);


--
-- TOC entry 5120 (class 1259 OID 17111)
-- Name: idx_study_sessions_user_started; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_sessions_user_started ON public.study_sessions USING btree (user_id, started_at DESC);


--
-- TOC entry 5044 (class 1259 OID 16700)
-- Name: uq_users_email_lower; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_users_email_lower ON public.users USING btree (lower((email)::text));


--
-- TOC entry 5136 (class 2606 OID 16678)
-- Name: admin_logs admin_logs_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_logs
    ADD CONSTRAINT admin_logs_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id);


--
-- TOC entry 5131 (class 2606 OID 16595)
-- Name: ai_recommendations ai_recommendations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_recommendations
    ADD CONSTRAINT ai_recommendations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5129 (class 2606 OID 16580)
-- Name: exam_results exam_results_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_results
    ADD CONSTRAINT exam_results_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id) ON DELETE CASCADE;


--
-- TOC entry 5130 (class 2606 OID 16575)
-- Name: exam_results exam_results_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_results
    ADD CONSTRAINT exam_results_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5126 (class 2606 OID 16545)
-- Name: exams exams_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id);


--
-- TOC entry 5127 (class 2606 OID 16540)
-- Name: exams exams_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE CASCADE;


--
-- TOC entry 5124 (class 2606 OID 16527)
-- Name: lesson_progress lesson_progress_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_progress
    ADD CONSTRAINT lesson_progress_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id) ON DELETE CASCADE;


--
-- TOC entry 5125 (class 2606 OID 16522)
-- Name: lesson_progress lesson_progress_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_progress
    ADD CONSTRAINT lesson_progress_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5123 (class 2606 OID 16509)
-- Name: lessons lessons_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE CASCADE;


--
-- TOC entry 5128 (class 2606 OID 16560)
-- Name: questions questions_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id) ON DELETE CASCADE;


--
-- TOC entry 5145 (class 2606 OID 17065)
-- Name: student_preference_difficult_subjects student_preference_difficult_subjects_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_preference_difficult_subjects
    ADD CONSTRAINT student_preference_difficult_subjects_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE RESTRICT;


--
-- TOC entry 5146 (class 2606 OID 17060)
-- Name: student_preference_difficult_subjects student_preference_difficult_subjects_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_preference_difficult_subjects
    ADD CONSTRAINT student_preference_difficult_subjects_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.student_preferences(user_id) ON DELETE CASCADE;


--
-- TOC entry 5144 (class 2606 OID 17046)
-- Name: student_preference_learning_methods student_preference_learning_methods_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_preference_learning_methods
    ADD CONSTRAINT student_preference_learning_methods_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.student_preferences(user_id) ON DELETE CASCADE;


--
-- TOC entry 5143 (class 2606 OID 17031)
-- Name: student_preferences student_preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_preferences
    ADD CONSTRAINT student_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5141 (class 2606 OID 16786)
-- Name: student_profile_subjects student_profile_subjects_student_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profile_subjects
    ADD CONSTRAINT student_profile_subjects_student_profile_id_fkey FOREIGN KEY (student_profile_id) REFERENCES public.student_profiles(id) ON DELETE CASCADE;


--
-- TOC entry 5142 (class 2606 OID 16791)
-- Name: student_profile_subjects student_profile_subjects_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profile_subjects
    ADD CONSTRAINT student_profile_subjects_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE CASCADE;


--
-- TOC entry 5140 (class 2606 OID 16769)
-- Name: student_profiles student_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5138 (class 2606 OID 16745)
-- Name: study_plan_items study_plan_items_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_items
    ADD CONSTRAINT study_plan_items_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id) ON DELETE CASCADE;


--
-- TOC entry 5139 (class 2606 OID 16740)
-- Name: study_plan_items study_plan_items_study_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_items
    ADD CONSTRAINT study_plan_items_study_plan_id_fkey FOREIGN KEY (study_plan_id) REFERENCES public.study_plans(id) ON DELETE CASCADE;


--
-- TOC entry 5132 (class 2606 OID 16722)
-- Name: study_plans study_plans_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plans
    ADD CONSTRAINT study_plans_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE SET NULL;


--
-- TOC entry 5133 (class 2606 OID 16611)
-- Name: study_plans study_plans_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plans
    ADD CONSTRAINT study_plans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5147 (class 2606 OID 17105)
-- Name: study_sessions study_sessions_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_sessions
    ADD CONSTRAINT study_sessions_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id) ON DELETE SET NULL;


--
-- TOC entry 5148 (class 2606 OID 17100)
-- Name: study_sessions study_sessions_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_sessions
    ADD CONSTRAINT study_sessions_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE SET NULL;


--
-- TOC entry 5149 (class 2606 OID 17095)
-- Name: study_sessions study_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_sessions
    ADD CONSTRAINT study_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5134 (class 2606 OID 16638)
-- Name: user_achievements user_achievements_achievement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_achievement_id_fkey FOREIGN KEY (achievement_id) REFERENCES public.achievements(id);


--
-- TOC entry 5135 (class 2606 OID 16633)
-- Name: user_achievements user_achievements_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5137 (class 2606 OID 16715)
-- Name: user_stats user_stats_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_stats
    ADD CONSTRAINT user_stats_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- Completed on 2026-04-05 01:00:20

--
-- PostgreSQL database dump complete
--

\unrestrict bxs1y3VnzZUjKTeZ7HwOiN3yYbGbHXbBAaz8igz5JdkHvOHxVf6IRezfL5FvzUJ

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict EFt5VdjATT25cyqhWLCOmsaQYDeK12ia05MgGv1Pe8SuYYTOnhpgdaGF5KWGZPL

-- Dumped from database version 18.2
-- Dumped by pg_dump version 18.2

-- Started on 2026-04-05 01:00:20

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-04-05 01:00:21

--
-- PostgreSQL database dump complete
--

\unrestrict EFt5VdjATT25cyqhWLCOmsaQYDeK12ia05MgGv1Pe8SuYYTOnhpgdaGF5KWGZPL

-- Completed on 2026-04-05 01:00:21

--
-- PostgreSQL database cluster dump complete
--

