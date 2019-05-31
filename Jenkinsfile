pipeline {
  agent any
  stages {
    if(env.BRANCH_NAME == 'master'){
      stage ('Build') {
        steps {
          sh '''#!/bin/bash
                   echo "MASTER practice"
                   pwd
                   ls -ltr
          '''
        }
      }
      stage ('Testing and testing') {
        steps {
            sh '''#!/bin/bash
                  echo "Entro a la segunda stage - Testing"
                  ls /tmp
                  whereis java
            '''
        }
      }
    }
    if(env.BRANCH_NAME == 'dev'){
      stage ('Final Stage') {
        steps {
          sh '''#!/bin/bash
                echo "Ha llegado a la ultima stage, la Final Stage - DEV Branch"        
          '''
        }
      }
    }
  }
}
