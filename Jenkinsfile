pipeline {
  agent any
  stages {
    stage ('Build') {
      steps {
        sh '''#!/bin/bash
                 echo "pipeline practice - DEV"
                 pwd
                 ls -ltr
         '''
      }
      stage ('Dev stage') {
        sh '''#!/bin/bash
              echo "Esta es la nueva stage, DEV Stage"
              ls /tmp
              whereis java
        '''
      }
      stage ('Final Stage') {
        sh '''#!/bin/bash
              echo "Ha llegado a la ultima stage, la Final Stage del DEV"        
        '''
      }
    }
  }
}
