pipeline {
  agent any
  stages {
    if (env.BRANCH_NAME == "master") {
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
  stages {
      if (env.BRANCH_NAME == "dev") {
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
