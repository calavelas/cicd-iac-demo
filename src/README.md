# test-devops
## Introduction

This is a technical test for the role of **DevOps Engineer**.

## Objectives

This test helps us to understand
- how do you approach infrastructure design
- how do you manage microservices communication
- how do you consider security implications

## Project Setup

Project root has [`index.js`](/index.js) file. It simulates a simple app that runs infinitely & sends metrics to a [`statsd`](https://github.com/statsd/statsd) server.

## Exercices

  1. Add a `Dockerfile` to containerize the app, with support for multiple environments (test, development & production)
  2. Add a `docker-compose.yml` file to setup Node app, `statsd` & the backend. Applicants can use any backends for `statsd` (eg: `Graphite`).
  3. Use any IAC tools (Cloudformation, Terraform etc.) to prepare the infrastructure
  4. (Optional) Deploy on any cloud computing platforms

## Submitting Your Code

Email us your Github repo. We expect meaningful git commits, ideally one commit per exercise with commit messages clearly communicating the intent.

In case you deploy it to any cloud platforms, please send us instructions & relevant IAM user credentials.