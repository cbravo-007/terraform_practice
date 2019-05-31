pipeline {
  agent any
  stages {
      stage ('Test') {
        if env.BRANCH_NAME == "master" {
          steps {
            sh '''#!/bin/bash
                  echo "MASTER practice"
                  pwd
                  ls -ltr
            '''
          }
        }
        if env.BRANCH_NAME == "dev" {
          steps {
            sh '''#!/bin/bash
                  echo "DEV practice"
                  pwd
                  ls -ltr
            '''
          }
        }
   }
}
