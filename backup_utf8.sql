--
-- PostgreSQL database dump
--

\restrict en0XvyYJXVOSLeAzuq670ARkbU6hf55NXifTg7eQIDYUUnw7tkaCFPaiFQqoKOB

-- Dumped from database version 15.13
-- Dumped by pg_dump version 15.17 (Debian 15.17-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: activity_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.activity_type_enum AS ENUM (
    'academic',
    'sports',
    'cultural',
    'club',
    'other'
);


ALTER TYPE public.activity_type_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity (
    id integer NOT NULL,
    name character varying NOT NULL,
    type public.activity_type_enum DEFAULT 'other'::public.activity_type_enum NOT NULL,
    description character varying NOT NULL,
    location character varying,
    date timestamp without time zone DEFAULT now() NOT NULL,
    duration integer NOT NULL,
    "isCompleted" boolean DEFAULT false NOT NULL,
    metadata text,
    classroom integer NOT NULL
);


ALTER TABLE public.activity OWNER TO postgres;

--
-- Name: activity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activity_id_seq OWNER TO postgres;

--
-- Name: activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.activity_id_seq OWNED BY public.activity.id;


--
-- Name: classroom; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classroom (
    id integer NOT NULL,
    name character varying NOT NULL,
    capacity integer NOT NULL,
    grade character varying NOT NULL,
    description character varying,
    "academicYear" character varying NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    location character varying(50) NOT NULL,
    "Specialization" character varying NOT NULL
);


ALTER TABLE public.classroom OWNER TO postgres;

--
-- Name: classroom_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.classroom_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.classroom_id_seq OWNER TO postgres;

--
-- Name: classroom_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.classroom_id_seq OWNED BY public.classroom.id;


--
-- Name: parent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parent (
    id integer NOT NULL,
    "firstName" character varying NOT NULL,
    "lastName" character varying NOT NULL,
    email character varying NOT NULL,
    "phoneNumber" character varying NOT NULL,
    "NCIN" integer NOT NULL,
    address character varying NOT NULL,
    "typeInsurance" character varying NOT NULL,
    "Numeroinsurance" character varying NOT NULL,
    job character varying NOT NULL
);


ALTER TABLE public.parent OWNER TO postgres;

--
-- Name: parent_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.parent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.parent_id_seq OWNER TO postgres;

--
-- Name: parent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.parent_id_seq OWNED BY public.parent.id;


--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    id integer NOT NULL,
    "firstName" character varying NOT NULL,
    "numeroInscriptio" character varying NOT NULL,
    "lastName" character varying NOT NULL,
    email character varying NOT NULL,
    "phoneNumber" character varying NOT NULL,
    address character varying NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "parentId" integer,
    "classroomId" integer,
    "dateOfBirth" date NOT NULL,
    "enrollmentDate" date NOT NULL
);


ALTER TABLE public.student OWNER TO postgres;

--
-- Name: student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_id_seq OWNER TO postgres;

--
-- Name: student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_id_seq OWNED BY public.student.id;


--
-- Name: teacher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher (
    id integer NOT NULL,
    "indexNumber" character varying NOT NULL,
    cin character varying NOT NULL,
    "firstName" character varying NOT NULL,
    surname character varying NOT NULL,
    gender character varying NOT NULL,
    address character varying NOT NULL,
    telephone character varying NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    facebook character varying,
    instagram character varying,
    linkedin character varying,
    specialization character varying NOT NULL,
    "profileImage" character varying NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "dateOfMandate" timestamp without time zone NOT NULL
);


ALTER TABLE public.teacher OWNER TO postgres;

--
-- Name: teacher_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teacher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teacher_id_seq OWNER TO postgres;

--
-- Name: teacher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teacher_id_seq OWNED BY public.teacher.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email text,
    "firstName" text,
    "lastName" text,
    phone text,
    picture text,
    address text,
    zipcode text,
    password text,
    "saltRounds" text,
    token text,
    active boolean DEFAULT true,
    "createdAt" timestamp with time zone,
    "createdBy" integer,
    "updatedAt" timestamp with time zone,
    "updatedBy" integer,
    "deletedAt" timestamp with time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: activity id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity ALTER COLUMN id SET DEFAULT nextval('public.activity_id_seq'::regclass);


--
-- Name: classroom id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom ALTER COLUMN id SET DEFAULT nextval('public.classroom_id_seq'::regclass);


--
-- Name: parent id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent ALTER COLUMN id SET DEFAULT nextval('public.parent_id_seq'::regclass);


--
-- Name: student id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student ALTER COLUMN id SET DEFAULT nextval('public.student_id_seq'::regclass);


--
-- Name: teacher id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher ALTER COLUMN id SET DEFAULT nextval('public.teacher_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: activity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activity (id, name, type, description, location, date, duration, "isCompleted", metadata, classroom) FROM stdin;
1	orthophonie:;;├╣ll	academic	seances d'hortophonie	utaim	2025-06-10 00:00:00	14	t	{"resources":[""],"attachments":[""],"comments":""}	1
\.


--
-- Data for Name: classroom; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classroom (id, name, capacity, grade, description, "academicYear", "isActive", location, "Specialization") FROM stdin;
1	educationSsssp├®cialis├®	8	1	classe des autistes 1		t	classe1	autisme
\.


--
-- Data for Name: parent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parent (id, "firstName", "lastName", email, "phoneNumber", "NCIN", address, "typeInsurance", "Numeroinsurance", job) FROM stdin;
1	Ahmed	Ben Salah	ahmed.bensalah@example.com	22112233	12345678	Rue de Tunis, Ariana	CNAM	INS123456789	Enseignant
2	houda	rouissi	houdaR@gmail.com	50987654	7564534	TOZEUR	CNAM	887654345678	enseignant
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student (id, "firstName", "numeroInscriptio", "lastName", email, "phoneNumber", address, "isActive", "parentId", "classroomId", "dateOfBirth", "enrollmentDate") FROM stdin;
1	nada		salhi		90545343	hammet jarid	t	2	\N	2025-06-02	2025-06-03
\.


--
-- Data for Name: teacher; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teacher (id, "indexNumber", cin, "firstName", surname, gender, address, telephone, email, password, facebook, instagram, linkedin, specialization, "profileImage", "createdAt", "dateOfMandate") FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, "firstName", "lastName", phone, picture, address, zipcode, password, "saltRounds", token, active, "createdAt", "createdBy", "updatedAt", "updatedBy", "deletedAt") FROM stdin;
2	hajerfahem@gmail.com	hajer	fahem	75632634	image	medenine	4100	$2b$10$Umz..9Y6nm5z7eWqPLrDrO33FJT3CHf/Ls.o3JD7tgEAxnUsLGHnW	$2b$10$Umz..9Y6nm5z7eWqPLrDrO	\N	t	2025-06-07 21:56:40.016+02	\N	\N	\N	\N
4	hajerfahem2024@gmail.com	hajer	fahem	75632634	image	medenine	4100	$2b$10$4b4wtCze5aBJ6ufYCk9KJusWxzcVWhPaBQswaOwoI/2.JRQOV4SqK	$2b$10$4b4wtCze5aBJ6ufYCk9KJu	\N	t	2025-06-07 21:57:55.286+02	\N	\N	\N	\N
5	admin@gmail.com	hajer	fahem	654367	image	medenine 	4100	$2b$10$tcLcLfZt8Sqz3aB/uPZ30OrIi/8ngYbMXstej4oQjxmTZO5NInmDW	$2b$10$tcLcLfZt8Sqz3aB/uPZ30O	\N	t	2025-06-07 22:49:58.385+02	\N	\N	\N	\N
1	imenhamada17@gmail.com	imen	Doe	+33612345678	https://example.com/images/john.jpg	123 rue de Paris	75001	$2b$10$r.NQjIWEqcUXP9GlrgK4MO/v.yHhMaJtjtO8QYy3t3UdZLAsQzKvq	$2b$10$r.NQjIWEqcUXP9GlrgK4MO	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9	t	2024-01-01 11:00:00+01	1	2025-06-14 11:51:19.695+02	2	\N
11	elinee@gmail.com	eline	souli	50555555	hhyyyyy	TOZEUR	2200	$2b$10$8MuumHmQN7QyBan543wN5.75VV04TZecmj48Cg878h6it2InV0Ksu	$2b$10$8MuumHmQN7QyBan543wN5.	\N	t	2025-06-14 16:58:55.524+02	\N	\N	\N	\N
\.


--
-- Name: activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.activity_id_seq', 1, true);


--
-- Name: classroom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classroom_id_seq', 1, true);


--
-- Name: parent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.parent_id_seq', 4, true);


--
-- Name: student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_id_seq', 1, true);


--
-- Name: teacher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teacher_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 13, true);


--
-- Name: activity PK_24625a1d6b1b089c8ae206fe467; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity
    ADD CONSTRAINT "PK_24625a1d6b1b089c8ae206fe467" PRIMARY KEY (id);


--
-- Name: teacher PK_2f807294148612a9751dacf1026; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT "PK_2f807294148612a9751dacf1026" PRIMARY KEY (id);


--
-- Name: student PK_3d8016e1cb58429474a3c041904; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT "PK_3d8016e1cb58429474a3c041904" PRIMARY KEY (id);


--
-- Name: classroom PK_729f896c8b7b96ddf10c341e6ff; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT "PK_729f896c8b7b96ddf10c341e6ff" PRIMARY KEY (id);


--
-- Name: users PK_a3ffb1c0c8416b9fc6f907b7433; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "PK_a3ffb1c0c8416b9fc6f907b7433" PRIMARY KEY (id);


--
-- Name: parent PK_bf93c41ee1ae1649869ebd05617; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent
    ADD CONSTRAINT "PK_bf93c41ee1ae1649869ebd05617" PRIMARY KEY (id);


--
-- Name: teacher UQ_00634394dce7677d531749ed8e8; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT "UQ_00634394dce7677d531749ed8e8" UNIQUE (email);


--
-- Name: parent UQ_9158391af7b8ca4911efaad8a73; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent
    ADD CONSTRAINT "UQ_9158391af7b8ca4911efaad8a73" UNIQUE (email);


--
-- Name: users UQ_97672ac88f789774dd47f7c8be3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "UQ_97672ac88f789774dd47f7c8be3" UNIQUE (email);


--
-- Name: student UQ_a56c051c91dbe1068ad683f536e; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT "UQ_a56c051c91dbe1068ad683f536e" UNIQUE (email);


--
-- Name: teacher UQ_b7b26d1adaa0130305dcff283a9; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT "UQ_b7b26d1adaa0130305dcff283a9" UNIQUE ("indexNumber");


--
-- Name: student FK_426224f5597213259b1d58fc0f4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT "FK_426224f5597213259b1d58fc0f4" FOREIGN KEY ("classroomId") REFERENCES public.classroom(id);


--
-- Name: student FK_d728e971c60c58a818dd9e614ab; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT "FK_d728e971c60c58a818dd9e614ab" FOREIGN KEY ("parentId") REFERENCES public.parent(id);


--
-- PostgreSQL database dump complete
--

\unrestrict en0XvyYJXVOSLeAzuq670ARkbU6hf55NXifTg7eQIDYUUnw7tkaCFPaiFQqoKOB

