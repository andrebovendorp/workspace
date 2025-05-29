# CI/CD Discussion
This was a discussion I had with a friend adout what is and how to implement an Enterprise grade CI/CD Pipeline. 

## Introduction
A CI/CD pipeline is a set of automated processes that allow developers to integrate code changes, test them, and deploy them to production environments efficiently. The main goal is to ensure that software can be released quickly and reliably.
CI/CD stands for Continuous Integration and Continuous Deployment (or Continuous Delivery). It is a set of practices that enable development teams to deliver code changes more frequently and reliably.

When developing CI/CD steps into a pipeline, its important to consider the time for iteration between each steps. eg: When commiting a code, there must be a fast feedback loop to the developer, so that he can fix issues quickly. 

> One important aspect of CI/CD is that the pipeline is highly bounded to the business logic of the company. This means that the steps and processes involved in the pipeline should vary significantly based on the specific needs and practices of the organization.

## CI/CD Pipeline Steps
Each step of CI/CD have a different contract that we should follow. The most common steps are:

### CI
- **Commit**: Developers commit code to a version control system (e.g., Git).
- **Test**: Automated tests are run to ensure code quality and functionality.
- **Build**: The code is built into an executable or deployable artifact.
- **Package**: The built artifact is packaged for deployment.
### CD (Delivery)
- **Delivery of Artifact**: The packaged artifact is delivered to a registry or repository.
- **Delivery of Context** : Context information (e.g., configuration, environment variables) is delivered alongside the artifact.
### CD (Deployment)
- **Deploy**: The delivered artifact is deployed using the delivered context to an environment configured in the context.

Its really important to separate CD (Delivery) and CD (Deployment) because the contract each step has is different and in many cases, these steps might be in different teams responsabilities since Deployment is closter to infrastructure and Delivery is closer to the Application Development.

Check the following diagram for a visual representation of the CI/CD pipeline:

![CI/CD Pipeline Diagram](CICD.svg)