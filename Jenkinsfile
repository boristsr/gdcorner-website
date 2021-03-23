pipeline {
    //Run only on docker agents compatible with jekyll
    agent { label 'docker-jenkins-jekyll' }

    environment {
        BUILD_ENVIRONMENT = 'development'
        OVERRIDE_URL = 'https://staging.gdcorner.net'
        AWS_STAGING_CREDENTIALS = 'cb2289b7-76c6-4711-8779-4b3800a3d0e8'
        AWS_STAGING_BUCKET = 'staging.gdcorner.net'
        AWS_STAGING_CF_DISTRIBUTION = 'E3COBJBCCYEPYE'
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
                    s3Delete bucket: AWS_STAGING_BUCKET, path: '/'
                    s3Upload acl: 'PublicRead', bucket: AWS_STAGING_BUCKET, file: '', workingDir: '_site/', cacheControl:'public,max-age=3600'
                    cfInvalidate distribution: AWS_STAGING_CF_DISTRIBUTION, paths: ['/*'], waitForCompletion: true
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


