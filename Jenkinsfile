pipeline {
    //Run only on docker agents compatible with jekyll
    agent { label 'docker-jenkins-jekyll' }

    environment {
        //Staging
        AWS_STAGING_CREDENTIALS = 'aws-gdcorner-blog-staging'
        AWS_STAGING_BUCKET = 'staging-gdcorner-website'
        AWS_STAGING_CF_DISTRIBUTION = 'E16GBWPX0BBJW5'
        AWS_STAGING_REGION = 'us-east-1'

        //UAT
        AWS_UAT_CREDENTIALS = 'aws-gdcorner-blog-uat'
        AWS_UAT_BUCKET = 'uat-gdcorner-website'
        AWS_UAT_CF_DISTRIBUTION = 'E26PKTK3GL3AYG'
        AWS_UAT_REGION = 'us-east-1'

        //Production
        AWS_PROD_CREDENTIALS = 'aws-gdcorner-blog-prod'
        AWS_PROD_BUCKET = 'www-gdcorner-website'
        AWS_PROD_CF_DISTRIBUTION = 'E3UQNBGHNAT97M'
        AWS_PROD_REGION = 'us-east-1'


        //Determine final values based on branch names
        AWS_CREDENTIALS_TEMP1 = "${env.BRANCH_NAME == 'staging' ? env.AWS_STAGING_CREDENTIALS : env.AWS_UAT_CREDENTIALS}"
        AWS_CREDENTIALS = "${env.BRANCH_NAME == 'master' ? env.AWS_PROD_CREDENTIALS : env.AWS_CREDENTIALS_TEMP1}"

        AWS_BUCKET_TEMP1 = "${env.BRANCH_NAME == 'staging' ? env.AWS_STAGING_BUCKET : env.AWS_UAT_BUCKET}"
        AWS_BUCKET = "${env.BRANCH_NAME == 'master' ? env.AWS_PROD_BUCKET : env.AWS_BUCKET_TEMP1}"

        AWS_CF_DISTRIBUTION_TEMP1 = "${env.BRANCH_NAME == 'staging' ? env.AWS_STAGING_CF_DISTRIBUTION : env.AWS_UAT_CF_DISTRIBUTION}"
        AWS_CF_DISTRIBUTION = "${env.BRANCH_NAME == 'master' ? env.AWS_PROD_CF_DISTRIBUTION : env.AWS_CF_DISTRIBUTION_TEMP1}"

        AWS_REGION_TEMP1 = "${env.BRANCH_NAME == 'staging' ? env.AWS_STAGING_REGION : env.AWS_UAT_REGION}"
        AWS_REGION = "${env.BRANCH_NAME == 'master' ? env.AWS_PROD_REGION : env.AWS_REGION_TEMP1}"

        
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
        stage('Build') {
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
        stage('Deploy') {
            steps {
                //deploy to AWS staging site
                withAWS(credentials: AWS_CREDENTIALS, region: AWS_REGION) {
                    s3Delete bucket: AWS_BUCKET, path: '/'
                    s3Upload acl: 'PublicRead', bucket: AWS_BUCKET, file: '', workingDir: '_site/', cacheControl:'public,max-age=3600'
                }
            }
        }
        stage('Invalidate CDN Cache') {
            steps {
                //deploy to AWS staging site
                withAWS(credentials: AWS_CREDENTIALS, region: AWS_REGION) {
                    cfInvalidate distribution: AWS_CF_DISTRIBUTION, paths: ['/*'], waitForCompletion: true
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


