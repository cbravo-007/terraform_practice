pipeline {
  agent any
  stages {
    stage ('Build') {
      steps {
        sh '''#!/bin/bash
                 echo "pipeline practice"
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
    stage ('Final Stage') {
      steps {
        sh '''#!/bin/bash
              echo "Ha llegado a la ultima stage, la Final Stage"        
        '''
      }
    }
  }
}
