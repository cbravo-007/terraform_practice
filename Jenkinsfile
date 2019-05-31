pipeline {
  agent any
  stages {
    stage ('Test') {
      steps {
        if (env.BRANCH_NAME == "master") {
          sh '''#!/bin/bash
                echo "MASTER practice"
                pwd
                ls -ltr
          '''
          }
        if (env.BRANCH_NAME == "dev") {
          sh '''#!/bin/bash
                echo "DEV practice"
                pwd
                ls -ltr
          '''
        }
      }
    }
  }
}
