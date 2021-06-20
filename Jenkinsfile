pipeline {
  agent {
    kubernetes {
      label 'address-book-demo'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  # Use service account that can deploy to all namespaces
  serviceAccount: jenkins
  containers:
  - name: maven
    image: public.ecr.aws/s5f4f9y1/maven:3.6-jdk-8
    command:
    - cat
    tty: true
    volumeMounts:
      - mountPath: "/root/.m2"
        name: m2
  - name: docker
    image: public.ecr.aws/s5f4f9y1/docker:latest
    command:
    - cat
    tty: true
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-sock
  - name: kubectl
    image: public.ecr.aws/s5f4f9y1/kubectl:latest
    command:
    - cat
    tty: true
    imagePullPolicy: IfNotPresent
    volumeMounts:
      - name: kubecfg
        mountPath: /root/.kube/config
  volumes:
    - name: kubecfg
      secret:
        secretName: kubecfg
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
    - name: m2
      persistentVolumeClaim:
        claimName: maven-pvc
"""
}
   }
  stages {
    stage ('checkout scm') {
     steps {
           git branch: 'master', url: "https://github.com/roshans416/eks-jenkins.git"
            }
        }
    stage('Build') {
      steps {
        container('maven') {
          sh """
            mvn package -DskipTests
          """
        }
      }
    }
    stage('Test') {
      steps {
        container('maven') {
          sh """
             mvn test
          """
        }
      }
    }
    stage('Push') {
      steps {
        container('docker') {
          sh """
             docker build -t 080424365188.dkr.ecr.ap-southeast-1.amazonaws.com/addressbook:latest .
             docker push 080424365188.dkr.ecr.ap-southeast-1.amazonaws.com/addressbook:latest  
          """
        }
      }
    }
   stage('Deploy to Kubernetes') {
    steps {
      container('kubectl') {
        sh """
           apply -f kubefiles/addressbook-deployment.yaml
       """
      }
    }
   }
   stage('Expose the service using serviceType LoadBalancer') {
     steps {
       container('kubectl') {
       sh """
          apply -f kubefiles/addressbook-service.yaml
          """
       }
     }
   }
  }
}
