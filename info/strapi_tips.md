
[Docker Images](https://hub.docker.com/r/strapi/strapi/)

## How to install a WYSIWYG editor

``` bash
$ docker -it exec strapi_host sh
    >:  npm i strapi-plugin-ckeditor5
# or
    >: npm i strapi-plugin-html-wysiwyg
>: npm run strapi build
```

## How to restore the configuration

``` bash
$ docker -it exec strapi_host sh
>: npm run strapi config:dump > dump.json
>: npm run strapi config:restore --file dump.json -s replace
```

The `strapi config:dump` and `strapi config:restore` only apply to the core_store table in the database, the actual model settings are stored in the `./api/*/models/*.settings.json` so you should be able to just copy the model settings over to the new project (or even just the model folder). So something like `cp -R api/somemodel /path/to/your/new/project/api/`.

## How to reset the password

``` bash
$ docker -it exec strapi_host sh
>: strapi admin:reset-password --email=<email> --password=<password>
```

## How to get access to the database

You should use the following command: 
``` bash
$ psql -p 15432 -h localhost -d strapi -U strapi
$ psql -p 1${STRAPI_DB_PORT} -h localhost -d ${STRAPI_DB_NAME} -U ${STRAPI_DB_USER}
```

``` SQL
SELECT * FROM strapi_administrator LIMIT 10;
UPDATE strapi_administrator SET email = 'name@domain.com' WHERE id = 1;
```

