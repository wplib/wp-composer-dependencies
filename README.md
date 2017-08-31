# Composer Dependencies for WordPress

## Table of Contents
- [Introduction](#introduction)
- [Searching](#searching)
- [Audience](#audience)
- [Benefits](#benefits)
- [Instructions](#instructions)
- [Implementation](#implementation)
- [Alternatives](#alternatives)
- [Pull-Requests](#pull-requests)
- [Roadmap](#roadmap)
- [Sponsoring](#sponsoring)
- [Why?](#why)
- [License](#license)

## Introduction

WPLib's [_Composer Dependencies for WordPress_](https://wplib.github.io/wp-dependencies/) is:
 
 1. A _working_ [**Composer**](https://getcomposer.org) repository containing plugins we like 
    _including GPL-licensed commercial plugins._
 1. An _example_ of how to create your own private/personal Composer repository using Git.
 1. _Specifically_ for developers who build WordPress sites, plugins and themes. 
 
When you use WPLib's _Composer Dependencies for WordPress_ as mentioned in #2 above you can store 
both of the following _all_ in one Git repository:
 
 1. Your complete Composer repository including all your zipped dependencies, and 
 2. The CircleCI source code for rebuilding your static Composer repository.

Or you can just use **this exact repository** as mentioned in #1 above and 
_just let us take care of the work for you._   

   
## Searching 
You can search for available plugins or themes or other WordPress-related dependencies at:

- https://wplib.github.io/wp-dependencies/


## Audience  
_Composer Dependencies for WordPress_ is for you if any of the following are true:
  
1. You are a **WordPress site developer** and you: 
    1. _Maintain a large number of WordPress projects and each of them uses `composer.json`._
    1. _Frequently create new WordPress projects, each with their own `composer.json`._
    1. _Periodically cannot rebuild your sites when you need to because WPackagist.org is down._
1. You **oversee WordPress development** for an agency or other organization and you: 
    1. _Need to limit your organization's developers from using any unapproved plugins._
1. You **create plugins or themes for WordPress** and you: 
    1. _Want to make life easier for many of your customers._
    1. _Would like to be an early contributor to gain exposure for your plugins or themes._
1. You **run a WordPress managed webhost** and you: 
    1. _Would like to provide a plugin and theme repository service for your customers._ 
 
## Benefits
_Composer Dependencies for WordPress_ provides some compelling benefits to Composer users.
 
But for you to understand those benefits **you might want to first read** [the pros and cons of using Composer for WordPress](Composer-for-WordPress.md). 


### Example without _Composer Dependencies for WordPress_ 

Envision you are setting up a `composer.json` file for a complex WordPress project that uses numerous plugins from many different sources. Those dependencies might be listed where the `composer.json` segment could look like this:

    "require": {
        "yoast/wordpress-seo-premium": ">=3.2.4",
        "facetwp/facetwp": ">=2.5",
        "johnpbloch/wordpress-core": ">=4.6",
        "wpackagist-plugin/query-monitor": "*",
        "wpackagist-plugin/helpful-information": "*",
        "wpackagist-theme/twentyseventeen": "*",
        "wpackagist-plugin/facebook-comments-plugin": ">=2.3.6",
        "wpackagist-plugin/google-sitemap-generator": ">=4.0.8",
        "wpackagist-plugin/post-types-order": ">=1.9.3.3",
        "wpackagist-plugin/sumome": ">=1.22",
        "wpackagist-plugin/woosidebars": ">=1.4.3",
        "wpackagist-plugin/json-rest-api": "1.2.5",
        "wpackagist-plugin/wp-cfm": ">=1.4.5",
        "wpackagist-plugin/pantheon-hud": ">=0.1.0",
        "wpackagist-plugin/carbon-fields": ">=1.6",
        "wpackagist-plugin/jetpack": ">=5.2.1",
        "wpackagist-plugin/disable-comments": ">=1.7",
        "wpackagist-plugin/duplicate-post": ">=3.2",
        "nprds/nprapi-wordpress": "dev-master",
        "algolia/algoliasearch-wordpress": ">=2.6.0",
        "wplib/wplib": ">=0.14.0",
        "wplib/wp-composer-installers": ">=1.0",
        "wplib/wp-devops": "dev-master"
    }

Now a major annoyance of Composer is that it requires you to **specify every single repository** separately from where you specified the dependencies themselves. _(Why Composer cannot assume it should just try looking at GitHub.com for a dependencies, or that is should allow developers to specify the repository inline with the dependency is beyond me?!?  But I digress...)_

So here is an example segment in a `composer.json` file for the repositories that might need to be included to support the above dependencies:

    "repositories": [
        {
            "type": "composer",
            "url": "https://wpackagist.org"
        },
        {
            "type": "git",
            "url": "https://github.com/wplib/wp-devops"
        },
        {
            "type": "git",
            "url": "https://github.com/wplib/wp-composer-installers"
        },
        {
            "type": "git",
            "url": "https://github.com/wplib/wplib.git"
        },
        {
            "type": "git",
            "url": "https://github.com/johnpbloch/wordpress-core"
        },
        {
            "type": "git",
            "url": "https://github.com/newclarity/facetwp.git"
        },
        {
            "type": "git",
            "url": "https://github.com/newclarity/wordpress-seo-premium.git"
        },
        {
            "type": "git",
            "url": "https://github.com/algolia/algoliasearch-wordpress.git"
        }
    ],
    

### Example WITH _Composer Dependencies for WordPress_ 

If you manage a lot of WordPress projects and thus a lot of `composer.json` files the above repositories list can become really tedious and error prone. But with **your own private/personal Composer repository** you can typically reduce your repositories down to just one, two, or just a few _(if you are actively developing a plugin in parallel with the site development, for example)_:         

    "repositories": [
        {
            "type": "composer",
            "url": "https://wpackagist.org"
        },
        {
            "type": "git",
            "url": "https://YOUR-GITHUB-ORG.github.io/wp-depenencies"
        }
    ],

**Then** whenever you need to add a new plugin or theme to any of your WordPress projects you add their repository, name and version required to your private/personal Composer repository _(by adding to a `satis.json` file &ndash; more on that in the [Instructions](#Instructions) section below)_ and then you only need list the specified dependencies you for each project in each project's respective `composer.json` file but not all the individual repositories too.


## Roadmap  

**Today** we have a **starter project** you can clone, modify to include your own plugins and themes, connect to CircleCI,  and then start using in less than an hour.  

We also have **a working repository** that The WPLib Team _(a.k.a [_NewClarity Consulting_](http://www.newclarity.net))_ uses for development of our own client's projects. At the time of launching this repo it contains a few different GPL-licensed commercial plugins that we have purchased and like to use. But Git is not a great solution for hosting a large number of .ZIP files, so we also need to extend this project.
 
For the future we would like to do the following:

1. **Support hosting the repository elsewhere in addition to GitHub**, critical for larger repositories. Minimally we would like to implement [Amazon S3](https://aws.amazon.com/s3/) and any (S)FTP server for deployment.  We would also be interested in supporting any other file host who would be interested in sponsoring our efforts. Tweet us at [@wplib](https://twitter.com/wplib) if you are interested.

2. **Host all well-known plugins and themes for WordPress**, including all open-source licensed commercial 3rd party plugins and themes to simplify the life of the professional WordPress site builder. Of course this will be **expensive** so if you are interested in sponsoring us in this effort, tweet us at [@wplib](https://twitter.com/wplib) for us to explore the fit.

	And if you have purchased an open-source plugin or theme that is not publicly accessible to Composer and want to see us add it to our repository you can either tweet us at [@wplib](https://twitter.com/wplib) or fork this repository and submit a pull request with your new plugin included. Pull request instructions [below](#pull-requests).

3. **Implement license checking for commercial plugins and themes** so that vendors will even be happy for us to host their plugins and themes that they do not normally distribute publicly. Again, to simplify the life of the WordPress site builder. If you are a vendor and find this intriguing please tweet us at [@wplib](https://twitter.com/wplib) to get the ball rolling.

4. **Provide support for a WordPress-specific alternative to Composer** so WordPress developers don't have to always deal with tools that are as complex to use as Composer when they could be must simpler.

   
## Instructions
To **use OUR Composer repository in your WordPress-related projects** just add the following to the  `.repositories` section of your project's `composer.json`  file:

    {
        "type": "git",
        "url": "https://wplib.github.io/wp-depenencies"
    }

To **create your own private/personal Composer repository** just clone this repo on Git and then... 

**[Instructions to come]**


## Implementation
We use [**Satis**](https://getcomposer.org/doc/articles/handling-private-packages-with-satis.md) 
to generate the repository and [CircleCI](http://circleci.com) to rebuild the repository whenever we have a update.  

## Alternatives

There are two well-known alternatives: [WPackagist.org](http://wpackagist.org) and [Packagist.org](http://packagist.org), both of which are useful in conjunction with _Composer Dependencies for WordPress_. In fact we reference WPackagist.org in the `satis.json` file we use to build our static repositories.

### WPackagist.org
1. Currently _Composer Dependencies for WordPress_ contains a **much smaller list of plugins and themes** than WPackagist, but we intend to grow it given interest from you and others.

2. Unlike WPackagist _Composer Dependencies for WordPress_ contains select commercial plugins _(that are open-source)_ as well as forks of GitHub-hosted plugins whose source repository did not include a `composer.json` file.

### Packagist.org
1. Packagist is primarily for [PHP libraries](https://tutorialzine.com/2013/02/24-cool-php-libraries-you-should-know-about) whereas _Composer Dependencies for WordPress_ is for WordPress plugins and themes.

## Pull-Requests

1. If you develop a line of plugins or themes and would like to contribute yours to this repository please tweet us at [@wplib](https://twitter.com/wplib) to start a dialog, or you can [create an issue](/wplib/wp-dependencies/issues) for discussion.

2. If you have any _**GPL-licensed**_ 3rd party plugins or themes that are not available to be downloaded by Composer and would like to change that, please fork this repo, add your contribution, and then [submit a pull-request](/wplib/wp-dependencies/pulls). We will give serious consideration to adding every submission.

	**[Instructions to come]**

## Why?

Why did we build this?  _(And why did we build [_Composer Installers for WordPress_](/wplib-wp-composer-installers) too?)_  

**Simply because we got damn tired** of maintaining all those repository references in our `composer.json` files.  

We really do have a love/hate relationship with Composer.

## Sponsoring
Interested in sponsoring this project to leverage it to promote your web infrastructure or WordPress-related business?  We love sponsors!  Tweet us at [@wplib](https://twitter.com/wplib) and we'll be happy to start a dialog.

## License

_Composer Dependencies for WordPress_ is licensed via [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html).

