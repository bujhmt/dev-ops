def folder_name = 'examples/mock_service'
def job_name = 'MockService'

pipelineJob(job_name) {
  displayName('Mock Service')
  logRotator {
    numToKeep(5)
  }
    parameters{
      gitParameter{
        name('GIT_BRANCH')
        defaultValue('master')
        description('Branch or tag to use for jobs')
        type('PT_BRANCH_TAG')
        branch('')
        branchFilter('origin/(.*)')
        tagFilter('*')
        sortMode('DESCENDING_SMART')
        selectedValue('NONE')
        useRepository('')
        quickFilterEnabled(true)
      }
      booleanParam('FAIL_ON_XRAY', true, 'Fail the build if xray scan returns violations')
    }
  definition {
    cpsScm {
      scm {
        git {
          remote {
            credentials('/github-emu/token')
            github('project/mock-service')
          }
          branches('${GIT_BRANCH}')
        }
      }
      scriptPath('jobs/pipeline.jenkinsfile')
      lightweight(false)
    }
  }
}