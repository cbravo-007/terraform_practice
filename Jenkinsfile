pipeline {
  agent any
  if (env.BRANCH_NAME == "master") {
    stages {
      stage ('Test') {
        
          steps {
            sh '''#!/bin/bash
                  echo "MASTER practice"
                  pwd
                  ls -ltr
            '''
          }
        }
    }
  }
  if (env.BRANCH_NAME == "dev") {
    stages {
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
