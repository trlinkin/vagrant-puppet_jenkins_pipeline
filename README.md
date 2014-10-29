# vagrant-puppet_jenkins_pipeline

## Assumptions

* You have an Internet connection that isn't filtered
* You have _puppet-librarian_ or _R10K_ -- to fetch modules from the
  Internet


## Initial Setup

There is some light setup to get started. Since this example is built
using Puppet Modules, but commiting them in this repo and Git sub-trees
are annoying, they must be fetched. This step is simple enough however.

Under the `/puppet` directory in this project, you will find a
`Puppetfile`. I've kept the `Puppetfile` syntax basic enough that it
should work for both _Librarian-Puppet_ and _R10K_ (yes, R10K adds
some special additional syntax to the abilities of the Puppetfile,
go check it out).

Setup Steps:
* Change directory to `/puppet`
* Run `librarian-puppet install` --or-- `r10k puppetfile install` (no,
  really, your choice)

## Build the Environment

```
vagrant up
```

This environment should be entirely self building. If your modules have
been correctly downloaded as per the initialization steps, it should
start just fine. All the other dependencies will be coming from the
Internet. The Vagrant base box will come from the Vagrant Cloud. Jenkins
itself will be downloaded from the Jenkins YUM repositories. The Jenkins
plugins will be downloaded and installed from Jenkins. Lastly the module
we're testing will be pulled from the _puppetlabs_ organization on GitHub.
