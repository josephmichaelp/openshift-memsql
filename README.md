# openshift-memsql

Template for running a apache php on a container based on alpine linux/openshift/docker.

### Installation

You need oc (https://github.com/openshift/origin/releases) locally installed:

create a new project (change to your whishes) or add this to your existing project

```sh
oc new-project openshift-memsql \
    --description="memSQL" \
    --display-name="memSQL"
```

Deploy (externally)

```sh
oc new-app https://github.com/weepee-org/openshift-memsql.git --name memsql
```

Deploy (weepee internally)
add to Your buildconfig
```yaml
spec:
  strategy:
    dockerStrategy:
      from:
        kind: ImageStreamTag
        name: memsql-server:latest
        namespace: weepee-registry
    type: Docker
```
use in your Dockerfile
```sh
FROM weepee-registry/memsql-server
```

You can add storage to /memsql for making the database persistent cross reboots

#### Route.yml

Create route for development and testing

```sh
curl https://raw.githubusercontent.com/weepee-org/openshift-memsql/master/Route.yaml | oc create -f -
```
