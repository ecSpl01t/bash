# bash

## control-meteor-project
echo 'alias cmp="PathToScript/service.sh"' >> ~/.bashrc 

------

$ cmp -p project-service -c command

### project-service
project-service first argument from ./config.sh

("someProject port path_meteor_project path_production")
```bash
PROJECTS+=("game_site 3005 /data/meteors/game_site /data/node/production/game_site");
```
then line will be:

$ cmp -p game_site -c status

------

If you don't have game_site.service, you need create service, you can make it from this line

cmp -s create-service -a game_site:3005:/data/meteors/game_site

or

cmp -s create-service -a game_site:3005:/data/node/production/game_site 


