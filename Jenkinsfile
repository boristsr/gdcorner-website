pipeline {
    //Run only on docker agents compatible with jekyll
    agent { label 'docker-jenkins-jekyll' }

    environment {
        AWS_STAGING_CREDENTIALS = 'aws-gdcorner-blog-staging'
        AWS_STAGING_BUCKET = 'staging.gdcorner.net'
        AWS_STAGING_CF_DISTRIBUTION = 'E3COBJBCCYEPYE'
    }

    options {
        timeout(time: 1, unit: 'HOURS') 
    }

    stages {
        stage('Install Prerequisites') {
            steps {
                //Execute build
                sh 'bash build/jenkins-docker-install.sh'
            }
        }
        stage('build-staging') {
            when {
                branch 'staging' 
            }
            environment {
                BUILD_ENVIRONMENT = 'staging'
            }
            steps {
                //Execute build
                sh 'bash build/jenkins-docker-build.sh'
            }
        }
        stage('build-production') {
            when {
                branch 'master' 
            }
            environment {
                BUILD_ENVIRONMENT = 'production'
            }
            steps {
                //Execute build
                sh 'bash build/jenkins-docker-build.sh'
            }
        }
        stage('Validate Search JSON') {
            steps {
                //Execute build
                sh 'jsonlint -qc _site/search.json'
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
                }
            }
        }
        stage('deploy-production') {
            when {
                branch 'master' 
            }

            steps {
                //deploy to AWS staging site
                withAWS(credentials: AWS_STAGING_CREDENTIALS, region: 'ap-southeast-2') {
                    s3Delete bucket: AWS_STAGING_BUCKET, path: '/'
                    s3Upload acl: 'PublicRead', bucket: AWS_STAGING_BUCKET, file: '', workingDir: '_site/', cacheControl:'public,max-age=3600'
                }
            }
        }
        stage('invalidate-cdn') {
            steps {
                //deploy to AWS staging site
                withAWS(credentials: AWS_STAGING_CREDENTIALS, region: 'ap-southeast-2') {
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
            discordSend description: "Job '${JOB_NAME}' (${BUILD_NUMBER}) pipeline completed with status '${currentBuild.currentResult}'\n\n${env.BUILD_URL}", footer: currentBuild.currentResult, result: currentBuild.currentResult, title: JOB_NAME, webhookURL: ANNOUNCE_URL_JOB_DISCORD
        }
    }
}


