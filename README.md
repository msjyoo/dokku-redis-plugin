The better Redis plugin for Dokku
---------------------------------

This is a Redis plugin for the Dokku Project, a self hosted PaaS in around 100 lines of code. You can find the project here: https://github.com/progrium/dokku

This plugin is a fork of another Dokku Redis plugin by **Vlorent Viel**, which you can find here: https://github.com/luxifer/dokku-redis-plugin

Installation
------------
```
$ sudo su # (Required for permissions - don't use sudo)
# cd /var/lib/dokku/plugins
# git clone --branch v1.0.0 --depth 1 https://github.com/sekjun9878/dokku-redis-plugin redis
# dokku plugins-install
```

Commands
--------
```
# dokku help
    redis:enable <app>     Enable Redis for an app for next build
    redis:destroy <app>    Destroy Redis container and volume of an app
```

Simple usage
------------
This Redis plugin is a bit different than other Redis plugins in that this uses pure Docker links, instead of publicising the port and using internal IPs therefore it is a lot more reliable (e.g. no internal IP changes after a redeploy.)

Also with this plugin, the Redis instance is managed for you. Unlike other plugins, you do not have to start your Redis server before you deploy. You simply have to enable Redis for an app, and the plugin will handle the start-up of the instance automatically.

Usage of Docker Links also means that the details of the Redis instance is provided directly inside environment variables.

**How to connect to Redis inside your app:**
The following environment variables are provided for you to connect to the Redis instance:
```
# Default Docker Link variables
REDIS_NAME=/<random_docker_generated_container_name>/redis
REDIS_PORT=tcp://<IPv4 Address>:6379
REDIS_PORT_6379_TCP=tcp://<IPv4 Address>:6379
REDIS_PORT_6379_TCP_PROTO=tcp
REDIS_PORT_6379_TCP_PORT=6379
REDIS_PORT_6379_TCP_ADDR=<IPv4 Address>

# Injected by this plugin
REDIS_URL=redis://redis:6379/0 # For devs: This is hardcoded but does not matter anyway.
```
Here is an example code for PHP, but for other languages accessing your environment variable should be straight forward.

Example code for PHP using https://github.com/phpredis/phpredis:
```
$app->redis = new Redis;
$app->redis->connect($_ENV["REDIS_PORT_6379_TCP_ADDR"], $_ENV["REDIS_PORT_6379_TCP_PORT"], 2);
```

`REDIS_URL` is also provided for when your library supports a simpler syntax such as ones used on Heroku.

Example simplified code for Ruby using https://github.com/redis/redis-rb using `REDIS_URL`:
```
require "redis"

redis = Redis.new
```

You can find more information about Docker Links here: https://docs.docker.com/userguide/dockerlinks/#environment-variables

**Enable Redis:**
To enable redis, an app must already exist with the same name. If you have not deployed yet, you can create a new blank app by doing:
```
# dokku apps:create example-org            # Server side
$ ssh dokku@server apps:create example-org # Client side

Creating example-org... done
```
Now enable Redis:
```
# dokku redis:enable example-org            # Server side
$ ssh dokku@server redis:enable example-org # Client side

-----> Enabling Redis for example-org...
=====> Redis enabled for example-org
       Redis will be started on next build / deploy
```

Deploy your app with the same name (client side):
Note: Output may be different depending on plugin version and environment.
```
$ git remote add dokku git@server:example-org
$ git push dokku master
Counting objects: 5, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (5/5), 422 bytes | 0 bytes/s, done.
Total 5 (delta 0), reused 0 (delta 0)
remote: -----> Cleaning up...
remote: -----> Building test from buildstep...
remote: -----> Adding BUILD_ENV to build environment...
remote: -----> PHP app detected

... blah blah blah ...

remote: -----> Releasing example-org...
remote: -----> Starting Redis for example-org...
remote: -----> Creating new volume
remote: -----> Starting Redis container...
remote: -----> Creating /home/dokku/example-org/LINK
remote: -----> Linking redis-example-org:redis with example-org
remote: -----> Redis container linked: example-org -> redis-example-org
remote: =====> Redis started:
remote:        Application: example-org
remote:        Redis: redis-example-org
remote: -----> Deploying example-org...
remote: -----> Running pre-flight checks

... blah blah blah ...

remote: -----> Running nginx-pre-reload
remote:        Reloading nginx
remote: =====> Application deployed:
remote:        http://example-org.server
```


Advanced usage
--------------

**Enable Redis for a application.** This will not take effect until the next rebuild / redeploy. Example is provided above in Simple usage.
```
dokku redis:enable example-org
```

**Destroy Redis for an application.** This completely destroys Redis for an application, **including all data**. Docker Links and Redis container will all be removed. This will prompt you for a verification. Please use carefully.
```
dokku redis:destroy example-org
```

License
--------------
```
The MIT License (MIT)

Copyright (c) 2015 Michael Yoo <michael@yoo.id.au>

Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
```
