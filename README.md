# Son of Deployinator
## DevOps Command API

[![Build Status](https://travis-ci.org/angelamancini/devops_control_api.svg?branch=master)](https://travis-ci.org/angelamancini/devops_control_api) [![Code Climate](https://codeclimate.com/github/angelamancini/devops_control_api/badges/gpa.svg)](https://codeclimate.com/github/angelamancini/devops_control_api) [![Test Coverage](https://codeclimate.com/github/angelamancini/devops_control_api/badges/coverage.svg)](https://codeclimate.com/github/angelamancini/devops_control_api/coverage) [![Dependency Status](https://gemnasium.com/badges/github.com/angelamancini/devops_control_api.svg)](https://gemnasium.com/github.com/angelamancini/devops_control_api) [![Inline docs](http://inch-ci.org/github/angelamancini/devops_control_api.svg?branch=master)](http://inch-ci.org/github/angelamancini/devops_control_api)

Deployinator was a project of mine that allowed users to deploy code from github to a set environment set up in Rightscale and AWS. Some lessons were learned and I decided to start fresh, this time as an API so that it can be consumed by a web frontend, a hubot in slack and any other thing I can think of at the time.

##Included modules:

**AWS**
* S3 File Copy - copy files from one s3 bucket to another
* S3 Check File - check if a specific filename exists in an S3 bucket
* EC2 Instance Lookup - find instances by uid, private ip, public ip, name or tags
* TODO - EC2 Launch - launch a server in a specific region, AZ and size
* TODO - EC2 Run command - ability to run commands on specific servers

**CloudFlare**
* Create Page Rule - create a page rule in CloudFlare
* Enable Page Rule - enable a page rule in CloudFlare
* Delete Page Rule - delete a page rule in CloudFlare

**Pingdom**
* TODO - Pause Monitor
* TODO - Unpause Monitor
