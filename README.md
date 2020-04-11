# amplify-elm

Docker image to build elm projects on AWS Amplify Console.

I must thank @butaca because the https://github.com/butaca/amplify-hugo project helped point me to the amazonlinux:2 image. 

For this version, I chose to run the `elm-repl` on the container rather than dumping to a shell. I could trim this image further by skipping the node install. This would mean `elm-repl` would not work. This doesn't matter in the Amplify Console, of course, unless some further build steps require additional node packages.

## unit testing

You could add `elm-test` and execute `npx elm-test` during the test phase. Add `elm-test` as a dev dependency in your package.json file and update your amplify build step accordingly.

## amplify build settings

Here is an example build file for amplify, including caching of the elm dependencies.

**Note**: with the custom build image Amplify does not seem to cache the build dependencies. The Provision step seems to take a while everytime, I am wondering if the custom build image does not support caching? I'll have to go back and try the default AWS image again to compare. =)

```
version: 0.1
frontend:
  phases:
    # IMPORTANT - Please verify your build commands
    build:
      commands:
        - elm make src/Main.elm --output=elm.js
  artifacts:
    # IMPORTANT - Please verify your build output directory
    baseDirectory: /
    files:
      - 'assets/**/*'
      - 'index.html'
      - 'elm.js'
  cache:
    paths:
      - node_modules/**/*
      - elm-stuff/**/*
```

## short history
First, this began with the awsamplifyconsole docker base image on dockerhub but this weighs in at 2G.

Next, Alpine Linux version totalled only 90M, but ran into the known issue that AWS Amplify Console does not support Alpine.

Lastly, based on Amazon Linux 2, this image with node and elm installed totals 440M.

Here are the results of my local experiments.

```
% docker images       
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
aahamlin97/awsamplify-elm   0.19.1              d018d9ef7590        7 minutes ago       439MB
aahamlin97/awsamplify-elm   latest              d018d9ef7590        7 minutes ago       439MB
aahamlin97/awsamplify-elm   2                   f789a4fb20e3        2 hours ago         88.9MB
aahamlin97/awsamplify-elm   1                   ea179b9d0f5c        24 hours ago        2GB
amazonlinux                 2                   cd2d92bc1c0c        10 days ago         163MB
```

