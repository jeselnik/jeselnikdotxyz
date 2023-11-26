---
title: "Book Matchmaking System"
date: 2022-06-21
draft: true
---

The original book matchmaking system was my chosen capstone project at RMIT
University near the conclusion of my Bachelor of Information Technology.

The minimal viable product specification was simple:

* Users can create accounts
* Users can search for books
* Users are able to list books they wish to sell
* Users can then order these books

What followed over the semester was a decent output but one that I wasn't happy with.

I can't post the code publicly but my problems with the project were:

* Spaghetti Code (My unfamiliarity with PHP didn't help in this regard)
* Unsanitised SQL Inputs
* Passwords stored in plaintext
* Lack of tests
* Complicated deployment
  * Instructions were to manually set up an apache server, then manually copy the files,
  manually set up the DB etc.

In mid 2022 I decided to redo the project myself to fix the problems I had with it
and create a showcase of sorts of the technology principles I learnt at my time at RMIT.

The original technology stack was Debian Linux, Apache Web Server, PHP & Postgres

The redo was done in:

* **Go** - My favourite programming language for personal projects.
  * While not taught at RMIT, the programming fundamentals learnt are more 
  of a general skill that can be applied over languages.
  * This solves part of the complicated deployment as Go programs compile to
  a single binary
  * The Gin framework was used to route the web pages.
* **Postgres** - Postgres was kept as the database due to functionality and
FOSS licensing.
  * As a showcase of university knowledge, the SQL taught in the database class
  on Oracle is transferrable.
* **Docker/Kubernetes (via minikube)** - Used to containerise the application
and simplify deployment
  * Taught at RMIT as part of the System Deployment and Operations class