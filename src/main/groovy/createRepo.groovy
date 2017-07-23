import org.sonatype.nexus.blobstore.api.BlobStoreManager
import org.sonatype.nexus.repository.maven.LayoutPolicy
import org.sonatype.nexus.repository.maven.VersionPolicy
import org.sonatype.nexus.repository.storage.WritePolicy
import groovy.json.JsonSlurper

parsed_args = new JsonSlurper().parseText(args)

def REPO_NAME=parsed_args.repo
def GROUP_NAME="${REPO_NAME}-group"

def manager = repository.getRepositoryManager()

if (manager.exists(REPO_NAME) || manager.exists(GROUP_NAME)) {
    return "ERROR: Repository '${REPO_NAME}' or group '${GROUP_NAME}' already existing"
}

repository.createMavenHosted(REPO_NAME, BlobStoreManager.DEFAULT_BLOBSTORE_NAME, false, VersionPolicy.RELEASE, WritePolicy.ALLOW, LayoutPolicy.PERMISSIVE)
repository.createMavenGroup(GROUP_NAME, [REPO_NAME, "maven-public"])

return "Repository '${REPO_NAME}' and group '${GROUP_NAME}' CREATED"