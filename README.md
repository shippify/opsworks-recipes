
# Credits
This repo was cloned from a bitbucket [repository](https://bitbucket.org/tnache/opsworks-recipes) from author [Thiago Nache](https://bitbucket.org/tnache)

For all cookbooks except: opsworks and alb, contact Thiago Nache B. de Carvalho <thiagonbcarvalho@gmail.com>

### What is this repository for? ###

* It contains Chef Recipes you should use on Amazon Opsworks.
* Beta version

# Cookbooks #

### Opsworks

#### Prerequisites
This helps automates your project deployments using Amazon Opsworks, Git, Docker and docker-compose. This cookbook requires the parameter `app` to be sent via Custom JSON and a file named `docker-compose-prod.yml` in the root of the project to function properly.

The list of supported parameters in the Custom JSON are:
- `app` - (\<String\>) name of your app (no spaces).
- `balancers` - (Array\<Object\>) target groups to which to register your instance. These Objects should have: `target-group-arn`(\<String\>), `region` (\<String\>), `ports` (Array\<String\>)
- `external-files` (Array\<Object\>) extra files that you may need for your project. These Objects should have: `path` (\<String\>), `environment`(Object\<String:String\>)
- `commands` (Array\<String\>) commands that you want executed in your instance.

Here is an example:
```javascript
{
"app":<my_app_name>,
"balancers":[{
"target-group-arn":<amazon target group ARN>,
"region":<amazon region (e.g. us-west-2)>,
"ports":[<port 1>]
},
.
.
.],
"external-files":[{
"path":<path/to/file.js>,
"environment":{
<"export const MY_FIRST_VAR">:<"'value 1'">,
<"export const MY_SECOND_VAR">:<"'value 2'">,
.
.
.
}
}],
"commands":["sudo docker exec -i my_container npm install",
"sudo docker exec -i my_container npm run build",
"sudo docker exec -i my_container supervisorctl restart all"]
}
```

#### Recipes

##### deploy
This recipe will:
- Stop existing containers of the app and remove them
- Erase existing folder of the project
- Pull the project with git
- Rebuild the containers

##### commands
This recipe will execute the commands passed in the Custom JSON

##### pull
This recipe will pull the latest changes from the deployed app

#### Recommendations
One fast way to update your servers would be to have in your layer:
- `setup`: docker-compose::default, opsworks::deploy
- `deploy`: opsworks::pull, opsworks::commands

This will update your processes without rebuilding your containers. If you can't restart your processes with the recipe commands then you should do it like this:
- `setup`: docker-compose::default
- `deploy`: opsworks::deploy

### How do I get set up? ###

* You just need an Amazon Web Service account.
