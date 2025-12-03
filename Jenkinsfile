pipeline {
    agent any

    environment {
        // Define Variables
        GIT_REPO = 'https://github.com/donfaruco/random-pass-api-deployment.git'
        BRANCH = 'main'
        PLAYBOOK = 'ansible/deploy_api.yml'
        ANSIBLE_SSH_CREDENTIAL = '4ansible' 
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${BRANCH}", url: "${GIT_REPO}"
            }
        }

        stage('Install Ansible') {
            steps {
                sh '''
                if ! command -v ansible >/dev/null; then
                    # NOTE: This stage assumes an Ubuntu/Debian-like agent is used.
                    sudo apt-get update
                    sudo apt-get install -y ansible
                fi
                '''
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                // Wrap the ansible-playbook command with sshagent.
                // This securely loads the private key associated with the ID '4ansible'
                // into an SSH agent session for the duration of this block.
                sshagent(credentials: [env.ANSIBLE_SSH_CREDENTIAL]) {
                    sh '''
                    export ANSIBLE_HOST_KEY_CHECKING=False
                    ansible-playbook -i ansible/inventory.ini ${PLAYBOOK} --force-handlers
                    curl http://54.218.252.194/health
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
