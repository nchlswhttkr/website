---
title: "A Little AWS Article"
description: ""
date: 2019-06-27T12:00:00+10:00
draft: true
layout: "single"
---

<!--more-->

Sometihng about CloudWatch Logs and the LambdaExecutionRole

---

When you make an API, you need to make a deployment
That deployment will contain only the methods that exist in your stack at the time of the deployment creation
Methods being an integration triggered by HTTP request to an API Gateway resource (basically a URL)
Updates to this deployment happen without replacement, which means it doesn't tear down the deployment and put a new one up
This means a few things
You have to make sure your deployments DependsOn on all of your API methods being created
If you wish to add a new method, you have to created an entirely new deployment, which I've only been able to do by redeploying my stack with the API deployment commented out, and then deploying again with it commented back in
This deletes the existing deployment resource and creates a new one at the same URL
Goodness forbid you forget a DependsOn on with your new API method
The interesting thing is that deleting this deployment doesn't seem to actually take down the URL the deployment produced
Maybe I mucked something up there
The nail in the coffin

> Wait, you have to specify every URL you want accessible?!

If you delete the function, resource and method that your deployment relies on to respond to a request, it will still allow that endpoint to be called and it will produce an "Internal Server Error" instead of "Missing authentication token" (the usual response when calling API Gateway with a method/resource combination that doesn't exist
Basically the deployment is what you need to make your AWS resources be internet-exposed, but once a deployment is created you cannot update it without replacing it entirely, and the resources it points to are static so you can't just add and remove resources as you go
The URL is a combination of a few things
The ID of your API
The region it's hosted
The name of the stage you gave your deployment
That forms the unique URL

> Seems really clunky
> "the name of the stage you gave your deployment" dafuq

CloudFormation is meant to initialise your stack, but not subsequent deployments it seems
https://cz29ex52sd.execute-api.ap-southeast-2.amazonaws.com/production/hello
API ID is cz...
StageName is production
You're accessing the /hello resource with a GET method
The thing about CloudFormation is it has this concept of replacement
When something gets updated (you add more processing power to your EC2, more DB storage, the location of your Lambda code), it can update the relevant resource by either destroying and recreating it, temporarily bringing it down and updating it, or performing the update with no downtime
The latter is superficial stuff like changing the resource description or human-readable name
Pretty much any applicable change I could make to the AWS::ApiGateway::Deployment resource is a "No interruption" type like the latter
So once a deployment is created you can't have updates be reflected, whether you add new resources or remove them
By the way, the manner in which you declare the connection is verbose
You create an API
You create a resource under that API (like /users)
You create a method under this users resource and declare an integration to make a POST request to an ARN that will lead to your Lambda function being invoked

> Seems like a hell of a lot of work to do really simple stuff...

You also need a few other things, like the Deployment we love so much, and a Permission to give API Gateway resources permission to invoke Lambdas
AWS offers a simpler templating style that transform a Serverless application into an acceptable stack
I didn't use it because I wanted to get an understanding of what AWS was doing under the hood
It really does feel like AWS is barely a platform as a service. Feels like it's just the same as if you were doing it on your own hardware, just the hardware is somewhere else
But muh scaling and \$30,000 bills from DynamoDB
Plz no XD
Why else does AWS have such good support? Cloud platforms are shit
People depend on the support because it gets so confusing
Oh man VPCs
You know Lambda coldstarts?

> Cold starts? What is this?

Each lambda function runs in a container
There is container created for every concurrent connection of every lambda
Calling HelloFunction and GoodbyeFunction will start up two containers in AWS
A container is typically kept "warm" for about 30 minutes after it is invoked
When you call a function and no containers are "warm", it needs to provision a new one

> "a container is created for every concurrent connection" wait what

This typically adds around 2 seconds to the user response time
Functions do not share containers, so a container used for HelloFunction would not later be used for Goodbye Function
If you called HelloFunction successively, it would use the same container
If you call HelloFunction concurrently though, that's two containers that need to spin up

> Seems there's a lot of ways to accidently spin up tons of containers

Yeah, you'll only pay for the containers you actually use when your functions are invoked
You don't pay for idle containers that are warm
NOW
If these containers need to run inside a VPC
As they do with Monash
AWS will provision an Elastic Network Interface for them
If your container is coming from a cold start, it will need to wait for an ENI to be created
This launches your user response time to around 15 seconds at a mininum
That's right 15 seconds
Every function gets its own cold starts
Every concurrent call might get a cold start
It seems AWS changed an architecture thing recently that allows all of your functions to share the same ENI
It was discussed at some conference a while ago, seems like it only recently came into effect (the past 2 weeks or so I think) but not really publicised
So a typical interaction with ERAMIS is that the first backend request takes upwards of 15 seconds

> W.t.f
> That's stupid

Backend calls after that are 3 seconds if it's an endpoint you haven't called yet, or <1s if it's warm
Is it work pre-starting the ENI in prod at least?
Yes, not sure how
I feel like it would be common to have some kind of half hourly cron that invokes all your functions to keep them warm
Just remember to include some kind of header/flag to terminate them immediately and minimise the memory/duration

> Or just a scaling option to keep 1 of each warm at all times

You can't do that
It's Serverless

> Seems dumb to need a from job for what would be a common problem I think
> That or just accept the first user every so often would tank the 15 sec load timr

It's the kind of thing you're meant to accept with the serverless architecture
The way I see it, don't transition your servers to serverless
I have other reasons for that besides this coldstart stuff
If you've got a service that's a bunch of purpose-build functions, that's where serverless comes in
I'm going to write this up somewhere
This would be a fun blog post
I did some fun stuff as well with S3 to make sure CloudFormation used the latest version of my code too
If the object bucket/key pairing doesn't change in your CloudFormation template, it won't update the code your Lambdas run off of
To force it to update, you need to point it to a different key to indicate that it should use different code
From what I can tell, each lambda basically copies the code from that S3 bucket, so if the code in the bucket changes it won't update the Lambda
That seems reasonable though, better to store a cooy than to try and grab it each time a function is invoked
S3 buckets could be seen as volatile

> I feel it's an issue when your on the smaller side, with not many users. When you have lots of users, this would be fine, as stuff would stay warm automatically. But as it is, with not many users, or periodic users, you will hit that 15sec startup alot

Serverless is fantastic when you're usually low/zero but want to handle sudden highs smoothly
Like a payroll system at 5pm Friday
At least that's what I think

> I'd agree with that. If you have enough users in general, I feel it can be good as well. Handling random peaks and troughs, but a consistent number to keep everything warm

yeah
containers stay warm for at least 20 minutes according to community investigation
AWS won't release anything on it
At least 20 minutes, then it goes up fairly linearly until it's certain you'll get a cold start at 60 minutes

> Hmmm, ok, so it's not horrible, just kinda bad

It's a more complex question than just what you need to scale to
It's more like how many concurrent requests do you need to scale to?

> Yea, with a fairly poor result if you miscalculate
> 2 secs spin up is huge :s
