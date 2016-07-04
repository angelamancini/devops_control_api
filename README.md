# DevOps Command API

[![Build Status](https://travis-ci.org/angelamancini/devops_control_api.svg?branch=master)](https://travis-ci.org/angelamancini/devops_control_api) [![Code Climate](https://codeclimate.com/github/angelamancini/devops_control_api/badges/gpa.svg)](https://codeclimate.com/github/angelamancini/devops_control_api) [![Test Coverage](https://codeclimate.com/github/angelamancini/devops_control_api/badges/coverage.svg)](https://codeclimate.com/github/angelamancini/devops_control_api/coverage) [![Dependency Status](https://gemnasium.com/badges/github.com/angelamancini/devops_control_api.svg)](https://gemnasium.com/github.com/angelamancini/devops_control_api) [![Inline docs](http://inch-ci.org/github/angelamancini/devops_control_api.svg?branch=master)](http://inch-ci.org/github/angelamancini/devops_control_api)

DOC is a way to perform common DevOps tasks through a shared API.

##Included modules:

**AWS**
* S3 File Copy - copy files from one s3 bucket to another
* S3 Check File - check if a specific filename exists in an S3 bucket
* EC2 Instance Lookup - find instances by uid, private ip, public ip, name or tags

**CloudFlare**
* Create Page Rule - create a page rule in CloudFlare
* Enable Page Rule - enable a page rule in CloudFlare
* Delete Page Rule - delete a page rule in CloudFlare

**GitHub**
* Create Release - Creates a release on a specified branch
* Update Release - Changes release from pre-release to release and adds a message to the description.
* List Releases - Lists the 30 most recent releases on a repo

**RightScale**
* Launch Server in Array
* Check Server Boot Status
* Terminate Server
* Update Server Array Inputs
* Retrieve Server Array Inputs
* Retrieve Server Array Audit Entries
