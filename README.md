## Capistrano 3 to deploy simple rest api RoR application

This basic configuration of capistrano deploys https://github.com/ivan7farre/rest_api an infrastructure provided by
https://github.com/ivan7farre/vagrant-aws-linux-RoR project.


Usage
-----

* Install capistrano ``` gem install capistrano ```
* Clone this repository
* Update deploy.rb file with your own configuration (public IP to access EC2 instance, path with private key)
  The private key could be provided with this file:
  https://raw.githubusercontent.com/ivan7farre/vagrant-aws-linux-RoR/master/deploy/files/id_rsa
* After running ``` cap staging setup:all ``` the rest_api application will be deployed and accessible 
* Modify puppet recipes as you wish
* Show capistrano tasks using ``` cap -T ```

