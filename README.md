# RABBITMQ

This repository holds the creation of RabbitMQ's docker image.

## But... why?

There's so many docker image allowing to launch RabbitMQ. So, why create another one?
Because this image will be created with the plugin `rabbitmq_prometheus` enabled and is use by the [Media Cloud AI](https://media-cloud.ai/) plateform.

## Launch

This docker image is based on the official RabbitMQ docker image (rabbitmq:3.8.5-management). So, you could read the [documentation](https://hub.docker.com/_/rabbitmq) to configure it with environment variables and to launch the container.

TL;DR;

To launch it using command line with environment variables:
```bash
docker run -d --hostname my-rabbit --name some-rabbit -e RABBITMQ_DEFAULT_USER=user -e RABBITMQ_DEFAULT_PASS=password -e RABBITMQ_DEFAULT_VHOST=my_vhost medialcoudai/rabbitmq:3.8.5 
```

## URLs access

| URL                                 | Description                                                  |
|-------------------------------------|--------------------------------------------------------------|
| http://[container IP]:15678/        | Management UI.                                               |
| http://[container IP]:15692/metrics | Access to exported metrics. Can be used as prometheus target. |

## CONFIGURATION

By default, generated metrics do not include metrics about specific queue (ie: number of message in each queue).
To activate this feature, you must set `prometheus.return_per_object_metrics` to `true`.
But this configuration cannot be handle by environment variable, so we must defined a RabbitMQ configuration file ans use it in the container through volume.

Example :

**rabbitmq.conf**:
```conf
loopback_users.guest = false
listeners.tcp.default = 5672
default_pass = mediacloudai
default_user = mediacloudai
default_vhost = media_cloud_ai
hipe_compile = false
management.listener.port = 15672
management.listener.ssl = false
prometheus.return_per_object_metrics = true
```

**docker-compose.yml**:
```yaml
---
version: "3.6"

services:
  rabbitmq:
    image: mediacloudai/rabbitmq:3.8.5
    ports:
      - 5678:5672
      - 15678:15672
    volumes:
      - ${PWD}/rabbitmq.conf:/etc/rabbitmq/rabbitmq.conf
```

Launch:
```bash
docker-compose up
```