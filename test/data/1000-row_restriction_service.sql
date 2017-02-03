--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.2
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: row_restriction_service; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA row_restriction_service;


ALTER SCHEMA row_restriction_service OWNER TO postgres;

SET search_path = row_restriction_service, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: action; Type: TABLE; Schema: row_restriction_service; Owner: postgres
--

CREATE TABLE action (
    id integer NOT NULL,
    identifier character varying(50) NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    deleted timestamp without time zone
);


ALTER TABLE action OWNER TO postgres;

--
-- Name: action_id_seq; Type: SEQUENCE; Schema: row_restriction_service; Owner: postgres
--

CREATE SEQUENCE action_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE action_id_seq OWNER TO postgres;

--
-- Name: action_id_seq; Type: SEQUENCE OWNED BY; Schema: row_restriction_service; Owner: postgres
--

ALTER SEQUENCE action_id_seq OWNED BY action.id;


--
-- Name: comparator; Type: TABLE; Schema: row_restriction_service; Owner: postgres
--

CREATE TABLE comparator (
    id integer NOT NULL,
    identifier character varying(50) NOT NULL,
    description text,
    created timestamp without time zone DEFAULT now() NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    deleted timestamp without time zone
);


ALTER TABLE comparator OWNER TO postgres;

--
-- Name: comparator_id_seq; Type: SEQUENCE; Schema: row_restriction_service; Owner: postgres
--

CREATE SEQUENCE comparator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comparator_id_seq OWNER TO postgres;

--
-- Name: comparator_id_seq; Type: SEQUENCE OWNED BY; Schema: row_restriction_service; Owner: postgres
--

ALTER SEQUENCE comparator_id_seq OWNED BY comparator.id;


--
-- Name: principal; Type: TABLE; Schema: row_restriction_service; Owner: postgres
--

CREATE TABLE principal (
    id integer NOT NULL,
    "id_principalType" integer NOT NULL,
    "principalId" integer NOT NULL
);


ALTER TABLE principal OWNER TO postgres;

--
-- Name: principalType; Type: TABLE; Schema: row_restriction_service; Owner: postgres
--

CREATE TABLE "principalType" (
    id integer NOT NULL,
    identifier character varying(50) NOT NULL
);


ALTER TABLE "principalType" OWNER TO postgres;

--
-- Name: principalType_id_seq; Type: SEQUENCE; Schema: row_restriction_service; Owner: postgres
--

CREATE SEQUENCE "principalType_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "principalType_id_seq" OWNER TO postgres;

--
-- Name: principalType_id_seq; Type: SEQUENCE OWNED BY; Schema: row_restriction_service; Owner: postgres
--

ALTER SEQUENCE "principalType_id_seq" OWNED BY "principalType".id;


--
-- Name: principal_id_seq; Type: SEQUENCE; Schema: row_restriction_service; Owner: postgres
--

CREATE SEQUENCE principal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE principal_id_seq OWNER TO postgres;

--
-- Name: principal_id_seq; Type: SEQUENCE OWNED BY; Schema: row_restriction_service; Owner: postgres
--

ALTER SEQUENCE principal_id_seq OWNED BY principal.id;


--
-- Name: principal_rowRestriction; Type: TABLE; Schema: row_restriction_service; Owner: postgres
--

CREATE TABLE "principal_rowRestriction" (
    "id_rowRestriction" integer NOT NULL,
    id_principal integer NOT NULL
);


ALTER TABLE "principal_rowRestriction" OWNER TO postgres;

--
-- Name: resource; Type: TABLE; Schema: row_restriction_service; Owner: postgres
--

CREATE TABLE resource (
    id integer NOT NULL,
    identifier character varying(50) NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    deleted timestamp without time zone
);


ALTER TABLE resource OWNER TO postgres;

--
-- Name: resource_id_seq; Type: SEQUENCE; Schema: row_restriction_service; Owner: postgres
--

CREATE SEQUENCE resource_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE resource_id_seq OWNER TO postgres;

--
-- Name: resource_id_seq; Type: SEQUENCE OWNED BY; Schema: row_restriction_service; Owner: postgres
--

ALTER SEQUENCE resource_id_seq OWNED BY resource.id;


--
-- Name: rowRestriction; Type: TABLE; Schema: row_restriction_service; Owner: postgres
--

CREATE TABLE "rowRestriction" (
    id integer NOT NULL,
    "id_valueType" integer NOT NULL,
    id_comparator integer NOT NULL,
    id_service integer NOT NULL,
    property character varying(200) NOT NULL,
    value json NOT NULL,
    nullable boolean DEFAULT false NOT NULL,
    global boolean DEFAULT false NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    created timestamp without time zone DEFAULT now() NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    deleted timestamp without time zone
);


ALTER TABLE "rowRestriction" OWNER TO postgres;

--
-- Name: rowRestriction_action; Type: TABLE; Schema: row_restriction_service; Owner: postgres
--

CREATE TABLE "rowRestriction_action" (
    "id_rowRestriction" integer NOT NULL,
    id_action integer NOT NULL
);


ALTER TABLE "rowRestriction_action" OWNER TO postgres;

--
-- Name: rowRestriction_id_seq; Type: SEQUENCE; Schema: row_restriction_service; Owner: postgres
--

CREATE SEQUENCE "rowRestriction_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "rowRestriction_id_seq" OWNER TO postgres;

--
-- Name: rowRestriction_id_seq; Type: SEQUENCE OWNED BY; Schema: row_restriction_service; Owner: postgres
--

ALTER SEQUENCE "rowRestriction_id_seq" OWNED BY "rowRestriction".id;


--
-- Name: rowRestriction_resource; Type: TABLE; Schema: row_restriction_service; Owner: postgres
--

CREATE TABLE "rowRestriction_resource" (
    "id_rowRestriction" integer NOT NULL,
    id_resource integer NOT NULL
);


ALTER TABLE "rowRestriction_resource" OWNER TO postgres;

--
-- Name: service; Type: TABLE; Schema: row_restriction_service; Owner: postgres
--

CREATE TABLE service (
    id integer NOT NULL,
    identifier character varying(50) NOT NULL
);


ALTER TABLE service OWNER TO postgres;

--
-- Name: service_id_seq; Type: SEQUENCE; Schema: row_restriction_service; Owner: postgres
--

CREATE SEQUENCE service_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE service_id_seq OWNER TO postgres;

--
-- Name: service_id_seq; Type: SEQUENCE OWNED BY; Schema: row_restriction_service; Owner: postgres
--

ALTER SEQUENCE service_id_seq OWNED BY service.id;


--
-- Name: valueType; Type: TABLE; Schema: row_restriction_service; Owner: postgres
--

CREATE TABLE "valueType" (
    id integer NOT NULL,
    identifier character varying(50) NOT NULL,
    description text,
    created timestamp without time zone DEFAULT now() NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    deleted timestamp without time zone
);


ALTER TABLE "valueType" OWNER TO postgres;

--
-- Name: valueType_id_seq; Type: SEQUENCE; Schema: row_restriction_service; Owner: postgres
--

CREATE SEQUENCE "valueType_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "valueType_id_seq" OWNER TO postgres;

--
-- Name: valueType_id_seq; Type: SEQUENCE OWNED BY; Schema: row_restriction_service; Owner: postgres
--

ALTER SEQUENCE "valueType_id_seq" OWNED BY "valueType".id;


--
-- Name: action id; Type: DEFAULT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY action ALTER COLUMN id SET DEFAULT nextval('action_id_seq'::regclass);


--
-- Name: comparator id; Type: DEFAULT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY comparator ALTER COLUMN id SET DEFAULT nextval('comparator_id_seq'::regclass);


--
-- Name: principal id; Type: DEFAULT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY principal ALTER COLUMN id SET DEFAULT nextval('principal_id_seq'::regclass);


--
-- Name: principalType id; Type: DEFAULT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "principalType" ALTER COLUMN id SET DEFAULT nextval('"principalType_id_seq"'::regclass);


--
-- Name: resource id; Type: DEFAULT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY resource ALTER COLUMN id SET DEFAULT nextval('resource_id_seq'::regclass);


--
-- Name: rowRestriction id; Type: DEFAULT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "rowRestriction" ALTER COLUMN id SET DEFAULT nextval('"rowRestriction_id_seq"'::regclass);


--
-- Name: service id; Type: DEFAULT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY service ALTER COLUMN id SET DEFAULT nextval('service_id_seq'::regclass);


--
-- Name: valueType id; Type: DEFAULT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "valueType" ALTER COLUMN id SET DEFAULT nextval('"valueType_id_seq"'::regclass);


--
-- Name: action action_pk; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY action
    ADD CONSTRAINT action_pk PRIMARY KEY (id);


--
-- Name: action action_unique_identifier; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY action
    ADD CONSTRAINT action_unique_identifier UNIQUE (identifier);


--
-- Name: comparator comparator_pk; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY comparator
    ADD CONSTRAINT comparator_pk PRIMARY KEY (id);


--
-- Name: comparator comparator_unique_identifier; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY comparator
    ADD CONSTRAINT comparator_unique_identifier UNIQUE (identifier);


--
-- Name: principalType principalType_pk; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "principalType"
    ADD CONSTRAINT "principalType_pk" PRIMARY KEY (id);


--
-- Name: principalType principalType_unique_identifier; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "principalType"
    ADD CONSTRAINT "principalType_unique_identifier" UNIQUE (identifier);


--
-- Name: principal principal_pk; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY principal
    ADD CONSTRAINT principal_pk PRIMARY KEY (id);


--
-- Name: principal_rowRestriction principal_rowRestrictionpk; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "principal_rowRestriction"
    ADD CONSTRAINT "principal_rowRestrictionpk" PRIMARY KEY ("id_rowRestriction", id_principal);


--
-- Name: principal principal_unique_principal; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY principal
    ADD CONSTRAINT principal_unique_principal UNIQUE ("id_principalType", "principalId");


--
-- Name: resource resource_pk; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_pk PRIMARY KEY (id);


--
-- Name: resource resource_unique_identifier; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY resource
    ADD CONSTRAINT resource_unique_identifier UNIQUE (identifier);


--
-- Name: rowRestriction_action rowRestriction_action_pk; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "rowRestriction_action"
    ADD CONSTRAINT "rowRestriction_action_pk" PRIMARY KEY ("id_rowRestriction", id_action);


--
-- Name: rowRestriction rowRestriction_pk; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "rowRestriction"
    ADD CONSTRAINT "rowRestriction_pk" PRIMARY KEY (id);


--
-- Name: rowRestriction_resource rowRestriction_resource_pk; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "rowRestriction_resource"
    ADD CONSTRAINT "rowRestriction_resource_pk" PRIMARY KEY ("id_rowRestriction", id_resource);


--
-- Name: service service_pk; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY service
    ADD CONSTRAINT service_pk PRIMARY KEY (id);


--
-- Name: service service_unique_identifier; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY service
    ADD CONSTRAINT service_unique_identifier UNIQUE (identifier);


--
-- Name: valueType valueType_pk; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "valueType"
    ADD CONSTRAINT "valueType_pk" PRIMARY KEY (id);


--
-- Name: valueType valueType_unique_identifier; Type: CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "valueType"
    ADD CONSTRAINT "valueType_unique_identifier" UNIQUE (identifier);


--
-- Name: principal principal_fk_principalType; Type: FK CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY principal
    ADD CONSTRAINT "principal_fk_principalType" FOREIGN KEY ("id_principalType") REFERENCES "principalType"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: principal_rowRestriction principal_rowRestriction_fk_principal; Type: FK CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "principal_rowRestriction"
    ADD CONSTRAINT "principal_rowRestriction_fk_principal" FOREIGN KEY (id_principal) REFERENCES principal(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: principal_rowRestriction principal_rowRestriction_fk_rowRestriction; Type: FK CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "principal_rowRestriction"
    ADD CONSTRAINT "principal_rowRestriction_fk_rowRestriction" FOREIGN KEY ("id_rowRestriction") REFERENCES "rowRestriction"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rowRestriction_action rowRestriction_action_fk_action; Type: FK CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "rowRestriction_action"
    ADD CONSTRAINT "rowRestriction_action_fk_action" FOREIGN KEY (id_action) REFERENCES action(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rowRestriction_action rowRestriction_action_fk_rowRestriction; Type: FK CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "rowRestriction_action"
    ADD CONSTRAINT "rowRestriction_action_fk_rowRestriction" FOREIGN KEY ("id_rowRestriction") REFERENCES "rowRestriction"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rowRestriction rowRestriction_fk_comparator; Type: FK CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "rowRestriction"
    ADD CONSTRAINT "rowRestriction_fk_comparator" FOREIGN KEY (id_comparator) REFERENCES comparator(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rowRestriction rowRestriction_fk_service; Type: FK CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "rowRestriction"
    ADD CONSTRAINT "rowRestriction_fk_service" FOREIGN KEY (id_service) REFERENCES service(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rowRestriction rowRestriction_fk_valueType; Type: FK CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "rowRestriction"
    ADD CONSTRAINT "rowRestriction_fk_valueType" FOREIGN KEY ("id_valueType") REFERENCES "valueType"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rowRestriction_resource rowRestriction_resource_fk_resource; Type: FK CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "rowRestriction_resource"
    ADD CONSTRAINT "rowRestriction_resource_fk_resource" FOREIGN KEY (id_resource) REFERENCES resource(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rowRestriction_resource rowRestriction_resource_fk_rowRestriction; Type: FK CONSTRAINT; Schema: row_restriction_service; Owner: postgres
--

ALTER TABLE ONLY "rowRestriction_resource"
    ADD CONSTRAINT "rowRestriction_resource_fk_rowRestriction" FOREIGN KEY ("id_rowRestriction") REFERENCES "rowRestriction"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

