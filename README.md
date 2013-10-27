### data-centric-programming

[This wiki about data-centric programming](https://github.com/leondutoit/data-centric-programming/wiki) gives you practical advice about how to work with data in a programmatic way. Doing that has many names - data analysis, data science (for the more fasionable) and so on. Whatever you call it, it requires an odd mixture of skills to do it in a sustainable and effective way.

The successful data analyst needs to adopt many software engineering best practices and master many small details related to data management in order to produce production ready analysis. This wiki aims to provide this knowledge.

This repo contains the code necessary to build the virtual machine that is used and discussed in the wiki. You can use it to reproduce every line of code that is discussed.

### Instructions

* [Download](https://www.virtualbox.org/wiki/Downloads) Oracle Virtual Box and install
* [Download](http://downloads.vagrantup.com/) Vagrant VM and install
* Install Virtual Box Guest Additions: `vagrant gem install vagrant-vbguest`
* Checkout this repository: `git clone git://github.com/leondutoit/data-centric-programming.git`
* Navigate to the repository folder locally: `cd data-centric-programming`
* Run `vagrant up`; this builds the virtual machine
* `vagrant --help` for command line help

To login: `vagrant ssh`. To log out `ctrl+d`. To access files on you host machine (the files in the repo) navigate to `/vagrant` in the VM.
