# Strapi

## Commands

```
source manage.sh postgres down
source manage.sh postgres up
source manage.sh postgres ps
source manage.sh postgres logs
```

## Volumes

``` bash
docker volume ls
docker volume inspect app_vol_post
```

## How to install a WYSIWYG editor

``` bash
docker -it exec strapi_host sh
    npm i strapi-plugin-ckeditor5
# or
    npm i strapi-plugin-html-wysiwyg
npm run strapi build
```

## How to restore the configuration

``` bash
docker -it exec strapi_host sh
npm run strapi config:dump > dump.json
npm run strapi config:restore --file dump.json -s replace
```

The `strapi config:dump` and `strapi config:restore` only apply to the core_store table in the database, the actual model settings are stored in the `./api/*/models/*.settings.json` so you should be able to just copy the model settings over to the new project (or even just the model folder). So something like `cp -R api/somemodel /path/to/your/new/project/api/`.

