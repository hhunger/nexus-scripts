import groovy.json.JsonSlurper

parsed_args = new JsonSlurper().parseText(args)

def REPO_NAME=parsed_args.repo
def GROUP_NAME="${REPO_NAME}-group"

def manager = repository.getRepositoryManager()

if (manager.exists(REPO_NAME)) {
    manager.delete(REPO_NAME)
}

if (manager.exists(GROUP_NAME)) {
    manager.delete(GROUP_NAME)
}

return "Repository '${REPO_NAME}' and group '${GROUP_NAME}' DELETED"