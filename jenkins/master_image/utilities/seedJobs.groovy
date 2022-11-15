def gitType = System.getenv('ENVIRONMENT') == 'prod' ? 'PT_TAG' : 'PT_BRANCH_TAG'

def folderName = 'DevOps'
def jobName = 'seedJobs'
def jobTitle = [folderName, jobName]

freeStyleJob(jobTitle.join('/')) {
  label('master')
  displayName('Seed Jobs - Global')
  description('Seed jobs available to Jenkins')
  logRotator {
    numToKeep(5)
    artifactNumToKeep(1)
  }
  triggers {
    hudsonStartupTrigger {
      quietPeriod('5')
      runOnChoice('ON_CONNECT')
      label('master')
      nodeParameterName('')
    }
  }
  parameters {
    gitParameter {
      name('BRANCH')
      defaultValue('master')
      description('Branch or tag to use for seedJobs')
      type(gitType)
      branch('')
      branchFilter('origin/(.)')
      tagFilter('')
      sortMode('DESCENDING_SMART')
      selectedValue('NONE')
      useRepository('')
      quickFilterEnabled(true)
    }
  }
  scm {
    git {
      remote {
        github('bujhmt/dev-ops', 'https')
      }
      branches('${BRANCH}')
    }
  }
  steps {
    action = System.getenv('ENVIRONMENT') == 'test' ? 'IGNORE' : 'DELETE'
    dsl {
      external('jenkins/jobs/*.groovy', 'jenkins/jobs/*/*.groovy')
      removeAction(action)
      removeViewAction(action)
    }
  }
}