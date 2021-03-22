pipeline {
    //Run only on docker agents compatible with jekyll
    agent { label 'docker-jenkins-jekyll' }

    environment {
        BUILD_ENVIRONMENT = 'development'
        OVERRIDE_URL = 'http://staging.gdcorner.net'
        AWS_STAGING_CREDENTIALS = 'cb2289b7-76c6-4711-8779-4b3800a3d0e8'
    }

    options {
        timeout(time: 1, unit: 'HOURS') 
    }

    stages {
        stage('build') {
            steps {
                //Execute build
                sh 'bash build/jenkins-docker-build.sh'
            }
        }
        stage('deploy-staging') {
            when {
                branch 'staging' 
            }

            steps {
                //deploy to AWS staging site
                withAWS(credentials: AWS_STAGING_CREDENTIALS, region: 'ap-southeast-2') {
                    s3Delete bucket: 'staging.gdcorner.net', path: '/'
                    s3Upload acl: 'PublicRead', bucket: 'staging.gdcorner.net', file: '', workingDir: '_site/'
                }
            }
        }
    }

    //archive the build
    post {
        success {
            //Archive the build artifacts
            archiveArtifacts artifacts: '_site/**/*', followSymlinks: false
        }
    }
}


