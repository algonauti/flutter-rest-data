# flutter_rest_data

This package is built on top of [rest_data](https://github.com/algonauti/dart-rest-data). It uses [hive](https://github.com/hivedb/hive) to store on local device all data coming from your REST backend.

[![CI](https://github.com/algonauti/flutter-rest-data/workflows/CI/badge.svg)](https://github.com/algonauti/flutter-rest-data/actions)

## Introduction

It provides your app with a REST Adapter which behaves as follows - see [rest_data](https://github.com/algonauti/dart-rest-data)'s Readme to learn what an Adapter is in these packages 😉 

* While device is online, it just stores on local device all REST data coming from the backend.
* When device is offline:
  * it returns data from local device on read operations
  * it stores added, updated and deleted records on local device
* When device gets back online (TODO):
  * it processes added, updated and deleted queues by sending the appropriate requests to the REST backend.

## To be continued...
