# Stampede Cloud

Docker stack configurations for nextcloud setup in a docker-compose file. The docker image used is nextcloud:latest.

#### Deployment

This particular setup of stampede-cloud requires [Docker] v19+ to run. Older versions will probably run just fine but have not been tested for compatibility.

After installing the correct version of docker engine, the server can be set up by running the following command.

For production environments...

```sh
$ docker swarm init
$ cd stampede-cloud/
$ docker stack deploy --compose-file=docker-compose.yml nextcloud
```

For development environments docker-compose is additionally required...

```sh
$ cd stampede-cloud/
$ docker-compose up -d
```

License
----

[MIT]

[//]: # (Reference links used in the body)
[Docker]: <https://www.docker.com>
[MIT]: <https://choosealicense.com/licenses/mit/>
