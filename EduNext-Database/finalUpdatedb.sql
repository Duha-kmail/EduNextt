--
-- PostgreSQL database dump
--

\restrict rSS0ASOXznje9eY9jhDf9X5U7qZSn6YbD3SgVVE2bSM86sUl6aGor9AfbhtPNrW

-- Dumped from database version 18.2
-- Dumped by pg_dump version 18.2

-- Started on 2026-03-11 05:06:03

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
-- TOC entry 5216 (class 0 OID 0)
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
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['student'::character varying, 'admin'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 5027 (class 2606 OID 16624)
-- Name: achievements achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.achievements
    ADD CONSTRAINT achievements_pkey PRIMARY KEY (id);


--
-- TOC entry 5039 (class 2606 OID 16677)
-- Name: admin_logs admin_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_logs
    ADD CONSTRAINT admin_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 5020 (class 2606 OID 16594)
-- Name: ai_recommendations ai_recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_recommendations
    ADD CONSTRAINT ai_recommendations_pkey PRIMARY KEY (id);


--
-- TOC entry 5016 (class 2606 OID 16574)
-- Name: exam_results exam_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_results
    ADD CONSTRAINT exam_results_pkey PRIMARY KEY (id);


--
-- TOC entry 5009 (class 2606 OID 16539)
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (id);


--
-- TOC entry 5033 (class 2606 OID 16654)
-- Name: faq faq_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faq
    ADD CONSTRAINT faq_pkey PRIMARY KEY (id);


--
-- TOC entry 5005 (class 2606 OID 16521)
-- Name: lesson_progress lesson_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_progress
    ADD CONSTRAINT lesson_progress_pkey PRIMARY KEY (id);


--
-- TOC entry 5001 (class 2606 OID 16508)
-- Name: lessons lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (id);


--
-- TOC entry 5014 (class 2606 OID 16559)
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- TOC entry 5035 (class 2606 OID 16667)
-- Name: site_content site_content_content_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_content
    ADD CONSTRAINT site_content_content_key_key UNIQUE (content_key);


--
-- TOC entry 5037 (class 2606 OID 16665)
-- Name: site_content site_content_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_content
    ADD CONSTRAINT site_content_pkey PRIMARY KEY (id);


--
-- TOC entry 5046 (class 2606 OID 16739)
-- Name: study_plan_items study_plan_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_items
    ADD CONSTRAINT study_plan_items_pkey PRIMARY KEY (id);


--
-- TOC entry 5025 (class 2606 OID 16610)
-- Name: study_plans study_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plans
    ADD CONSTRAINT study_plans_pkey PRIMARY KEY (id);


--
-- TOC entry 4997 (class 2606 OID 16498)
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- TOC entry 5007 (class 2606 OID 16685)
-- Name: lesson_progress uq_lesson_progress_user_lesson; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_progress
    ADD CONSTRAINT uq_lesson_progress_user_lesson UNIQUE (user_id, lesson_id);


--
-- TOC entry 5029 (class 2606 OID 16687)
-- Name: user_achievements uq_user_achievement; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT uq_user_achievement UNIQUE (user_id, achievement_id);


--
-- TOC entry 5031 (class 2606 OID 16632)
-- Name: user_achievements user_achievements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_pkey PRIMARY KEY (id);


--
-- TOC entry 5041 (class 2606 OID 16714)
-- Name: user_stats user_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_stats
    ADD CONSTRAINT user_stats_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4995 (class 2606 OID 16485)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 5021 (class 1259 OID 16694)
-- Name: idx_ai_recommendations_user_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_ai_recommendations_user_created ON public.ai_recommendations USING btree (user_id, created_at DESC);


--
-- TOC entry 5017 (class 1259 OID 16693)
-- Name: idx_exam_results_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_exam_results_user ON public.exam_results USING btree (user_id);


--
-- TOC entry 5018 (class 1259 OID 16692)
-- Name: idx_exam_results_user_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_exam_results_user_created ON public.exam_results USING btree (user_id, created_at DESC);


--
-- TOC entry 5010 (class 1259 OID 16698)
-- Name: idx_exams_lesson; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_exams_lesson ON public.exams USING btree (lesson_id);


--
-- TOC entry 5011 (class 1259 OID 16697)
-- Name: idx_exams_subject; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_exams_subject ON public.exams USING btree (subject_id);


--
-- TOC entry 5002 (class 1259 OID 16690)
-- Name: idx_lesson_progress_user_completed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lesson_progress_user_completed ON public.lesson_progress USING btree (user_id, completed);


--
-- TOC entry 5003 (class 1259 OID 16691)
-- Name: idx_lesson_progress_user_lesson; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lesson_progress_user_lesson ON public.lesson_progress USING btree (user_id, lesson_id);


--
-- TOC entry 4998 (class 1259 OID 16696)
-- Name: idx_lessons_subject; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lessons_subject ON public.lessons USING btree (subject_id);


--
-- TOC entry 4999 (class 1259 OID 16695)
-- Name: idx_lessons_subject_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lessons_subject_order ON public.lessons USING btree (subject_id, order_number);


--
-- TOC entry 5012 (class 1259 OID 16699)
-- Name: idx_questions_exam; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_questions_exam ON public.questions USING btree (exam_id);


--
-- TOC entry 5042 (class 1259 OID 16753)
-- Name: idx_study_plan_items_lesson; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_plan_items_lesson ON public.study_plan_items USING btree (lesson_id);


--
-- TOC entry 5043 (class 1259 OID 16752)
-- Name: idx_study_plan_items_plan; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_plan_items_plan ON public.study_plan_items USING btree (study_plan_id);


--
-- TOC entry 5044 (class 1259 OID 16754)
-- Name: idx_study_plan_items_plan_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_plan_items_plan_order ON public.study_plan_items USING btree (study_plan_id, order_number);


--
-- TOC entry 5022 (class 1259 OID 16751)
-- Name: idx_study_plans_subject; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_plans_subject ON public.study_plans USING btree (subject_id);


--
-- TOC entry 5023 (class 1259 OID 16750)
-- Name: idx_study_plans_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_plans_user ON public.study_plans USING btree (user_id);


--
-- TOC entry 4993 (class 1259 OID 16700)
-- Name: uq_users_email_lower; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_users_email_lower ON public.users USING btree (lower((email)::text));


--
-- TOC entry 5060 (class 2606 OID 16678)
-- Name: admin_logs admin_logs_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_logs
    ADD CONSTRAINT admin_logs_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id);


--
-- TOC entry 5055 (class 2606 OID 16595)
-- Name: ai_recommendations ai_recommendations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_recommendations
    ADD CONSTRAINT ai_recommendations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5053 (class 2606 OID 16580)
-- Name: exam_results exam_results_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_results
    ADD CONSTRAINT exam_results_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id) ON DELETE CASCADE;


--
-- TOC entry 5054 (class 2606 OID 16575)
-- Name: exam_results exam_results_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_results
    ADD CONSTRAINT exam_results_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5050 (class 2606 OID 16545)
-- Name: exams exams_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id);


--
-- TOC entry 5051 (class 2606 OID 16540)
-- Name: exams exams_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE CASCADE;


--
-- TOC entry 5048 (class 2606 OID 16527)
-- Name: lesson_progress lesson_progress_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_progress
    ADD CONSTRAINT lesson_progress_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id) ON DELETE CASCADE;


--
-- TOC entry 5049 (class 2606 OID 16522)
-- Name: lesson_progress lesson_progress_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_progress
    ADD CONSTRAINT lesson_progress_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5047 (class 2606 OID 16509)
-- Name: lessons lessons_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE CASCADE;


--
-- TOC entry 5052 (class 2606 OID 16560)
-- Name: questions questions_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id) ON DELETE CASCADE;


--
-- TOC entry 5062 (class 2606 OID 16745)
-- Name: study_plan_items study_plan_items_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_items
    ADD CONSTRAINT study_plan_items_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lessons(id) ON DELETE CASCADE;


--
-- TOC entry 5063 (class 2606 OID 16740)
-- Name: study_plan_items study_plan_items_study_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plan_items
    ADD CONSTRAINT study_plan_items_study_plan_id_fkey FOREIGN KEY (study_plan_id) REFERENCES public.study_plans(id) ON DELETE CASCADE;


--
-- TOC entry 5056 (class 2606 OID 16722)
-- Name: study_plans study_plans_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plans
    ADD CONSTRAINT study_plans_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE SET NULL;


--
-- TOC entry 5057 (class 2606 OID 16611)
-- Name: study_plans study_plans_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_plans
    ADD CONSTRAINT study_plans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5058 (class 2606 OID 16638)
-- Name: user_achievements user_achievements_achievement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_achievement_id_fkey FOREIGN KEY (achievement_id) REFERENCES public.achievements(id);


--
-- TOC entry 5059 (class 2606 OID 16633)
-- Name: user_achievements user_achievements_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_achievements
    ADD CONSTRAINT user_achievements_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 5061 (class 2606 OID 16715)
-- Name: user_stats user_stats_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_stats
    ADD CONSTRAINT user_stats_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- Completed on 2026-03-11 05:06:04

--
-- PostgreSQL database dump complete
--

\unrestrict rSS0ASOXznje9eY9jhDf9X5U7qZSn6YbD3SgVVE2bSM86sUl6aGor9AfbhtPNrW

