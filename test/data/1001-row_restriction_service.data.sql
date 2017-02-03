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

SET search_path = row_restriction_service, pg_catalog;

--
-- Data for Name: comparator; Type: TABLE DATA; Schema: row_restriction_service; Owner: postgres
--

COPY comparator (id, identifier, description, created, updated, deleted) FROM stdin;
1	equal	the value in the column must equal to	2017-02-03 22:20:20.297793	2017-02-03 22:20:20.297793	\N
2	notEqual	the value in the column must not equal to	2017-02-03 22:20:20.297793	2017-02-03 22:20:20.297793	\N
3	in	the value in the column must be one of	2017-02-03 22:20:20.297793	2017-02-03 22:20:20.297793	\N
4	notIn	the value in the column must be not on of	2017-02-03 22:20:20.297793	2017-02-03 22:20:20.297793	\N
5	gt	the value in the column must be greather than	2017-02-03 22:20:20.297793	2017-02-03 22:20:20.297793	\N
6	lt	the value in the column must be less than	2017-02-03 22:20:20.297793	2017-02-03 22:20:20.297793	\N
7	gte	the value in the column must be greather than or equal to	2017-02-03 22:20:20.297793	2017-02-03 22:20:20.297793	\N
8	lte	the value in the column must be less than or equal to	2017-02-03 22:20:20.297793	2017-02-03 22:20:20.297793	\N
\.


--
-- Name: comparator_id_seq; Type: SEQUENCE SET; Schema: row_restriction_service; Owner: postgres
--

SELECT pg_catalog.setval('comparator_id_seq', 8, true);


--
-- Data for Name: principalType; Type: TABLE DATA; Schema: row_restriction_service; Owner: postgres
--

COPY "principalType" (id, identifier) FROM stdin;
1	role
\.


--
-- Name: principalType_id_seq; Type: SEQUENCE SET; Schema: row_restriction_service; Owner: postgres
--

SELECT pg_catalog.setval('"principalType_id_seq"', 1, true);


--
-- Data for Name: valueType; Type: TABLE DATA; Schema: row_restriction_service; Owner: postgres
--

COPY "valueType" (id, identifier, description, created, updated, deleted) FROM stdin;
1	constant	the column must be compared to a constant value	2017-02-03 22:20:20.297793	2017-02-03 22:20:20.297793	\N
2	function	the column must be compared to the result fo a function	2017-02-03 22:20:20.297793	2017-02-03 22:20:20.297793	\N
3	variable	the column must be compared to a variable	2017-02-03 22:20:20.297793	2017-02-03 22:20:20.297793	\N
\.


--
-- Name: valueType_id_seq; Type: SEQUENCE SET; Schema: row_restriction_service; Owner: postgres
--

SELECT pg_catalog.setval('"valueType_id_seq"', 3, true);


--
-- PostgreSQL database dump complete
--

