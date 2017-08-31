# Is Composer a Good Fit for WordPress?
_Composer is an interesting beast._  We here are The WPLib Team think that Composer is a lot like Democracy:


>  _"Composer is the worst tool for managing a WordPress project, except for all the other tools that have been tried from time to time."_

In fairness, Composer is a tremendously useful for tool for managing a WordPress project for
[many different reasons](http://blog.nelm.io/2011/12/composer-part-1-what-why/), especially if 
want to manage your projects using a professional-level of best practices. **Still, I did not say it would be easy.**
 
## Composer was designed for PHP framework developers
Composer was **not** designed to work optimally with WordPress. Composer was instead designed for PHP projects that implement the [PHP Framework Interop Group](http://www.php-fig.org/psr/)'s set of [PHP Standards Recommendations _(PSRs)_](http://www.php-fig.org/psr/). PHP frameworks such as [Laravel, Symphony and Yii](http://noeticforce.com/best-php-frameworks-for-modern-web-development) are designed with those PSRs in mind and they generally implement them diligently. 

As such Composer and PHP Frameworks are like a match made in Heaven, so to speak.

## WordPress was designed for end-users
 
But WordPress is not a PHP Framework and it does not natively support PSRs so it is overly complicated to use with WordPress. 

You see PHP Frameworks are intended to be used by PHP developers who build and maintain websites where any new additional functionality is deployed to hosting _by the developer or a sysadmin._ If they need to add a PHP library to their site, they use a build and deploy process for which Composer can be a brilliant component of that process.

But WordPress was not designed for PHP developers to deploy websites whenever they want to add a new bit of functionality. WordPress was designed for end-users with no programming skill whatsoever and very little technical skill to be able to take control of site administration. WordPress was designed for these end-user to be able to change themes or add/update new plugins. 

The result is WordPress' model of new feature deployment directly conflicts with the model used by PHP framework for which Composer was designed to be used with. And that is as is should be for the needs of all the motivated end-users who want to manage their own WordPress' site.

## But WordPress professionals differ
If you are a professional WordPress site builder and you build, deploy and manage sites for clients then your needs are different from the average motivated end-user. You need professional workflow to help you streamline the complexity of building and maintaining a large number of sites.  And this is where Composer shines for WordPress.  

Composer can be an extremely useful tool to help you build and maintain lots of WordPress sites.

But Composer and WordPress are still like mixing oil and water.
 
## How are Composer and WordPress mismatched?

The basic reasons Composer is mismatched for WordPress include the extra efforts required to:

1. **Define the web location of plugins and themes**

	Unless you tell it otherwise Composer assumes all dependencies are PHP libraries whose locations can be found at [Packagist.org](http://packagist.org). Packagist is a directory of PHP libraries available at code hosting locations across the web such as [GitHub.com](http://github.com). And these days almost every developer of an open-source PHP library has listed their library at Packagist. 

	Unfortunately for WordPress developers, however, most open-source code for use with WordPress is delivered as a plugin and not as a _"proper"_ PHP Library. _(Proper PHP libraries can typically be used by WordPress site developers without a problem, but using PHP libraries inside a distributed theme or plugin begs conflicts with any other plugin that happens to load the same library. So use PHP libraries in your own plugins and themes at the risk of your users, unfortunately.)_ 
	
	So minimally WordPress developers have to add a reference to [WPackagist.org](https:/wpackagist.org) which is a WordPress plugin and theme directory that is equivalent to Packagist. WPackagist is run by [a well-meaning agency](https://outlandish.com/) for the good of the WordPress community &mdash; which is to be praised &mdash; but they [currently offer no service level guarantee](https://outlandish.com/projects/wpackagist/) and we have seen it go down for over 24 hours at least once in recent days.

	WPackagist includes all the open-source plugins and themes available at WordPress.org. The benefit it provides is to allow you to use Composer with plugins and themes from WordPress.org for which the vast majority do not include an otherwise required `composer.json` file 
	
	What WPackagist does not provide any commercial plugins or themes such as those a [CodeCanyon](https://codecanyon.net/), [ThemeForest](https://themeforest.net/) nor any plugins or themes from other independent vendors. The upshot is for these you must create your own repositories. **And that is one of the key benefits of using _Composer Dependencies for WordPress_**!

1. **Get a `composer.json` file added to plugins and themes that do not have one**

	Speaking of Composer requiring all dependencies to include a `composer.json` file that defines the name and type of the _"package"_. This means that any WordPress plugins or themes published on GitHub that do not include a `composer.json` require you to convince the developer to accept a pull request or just fork and maintain separately. And the latter is often the path of least resistance.  

	So if you are going to fork and maintain it, why not use _Composer Dependencies for WordPress_ to make it easier?

1. **Specify the correct directories for plugins, themes and WordPress core**

    Because Composer was designed to provide PSR support it assumes all dependences will be stored in a `/vendor/` directory.  WordPress, of course, wants to put themes in `/wp-content/themes/` and plugins in either `/wp-content/plugins/` or `/wp-content/mu-plugins/`.  So in order to communicate these specifics to Composer you have to specify a lot of tedious-in-maintain path mappings in the `composer.json` file. 

	Fortunately we have a WPLib project designed to simplify this aspect of Composer for WordPress site builders. We call it [_Composer Installers for WordPress_. **Check it out**](/wplib/wp-composer-installers)!


	_(P.S. If we had a WordPress-specific solution all we would need to do is simply specify the names of the plugin. But I digress...)_

1. **Modify the default directory layout of WordPress**

	To make matters worse, WordPress puts itself in the web root and Composer assumes that any dependency fully owns its own directory and anything below it, so if you use Composer to put WordPress in the web root wipes out both `/wp-config.php` as well as everything in `/wp-content/`!

	**Composer simply cannot work with the default WordPress directory layout** _assuming_ you manage WordPress itself as a dependencies _(and why would you not want to do that?)_.  
	
	
	So to support Composer [Mark Jaquith](http://markjaquith.com/) &mdash; one of the lead developers on WordPress  &mdash; specified [the WordPress Skeleton layout](https://markjaquith.wordpress.com/2012/05/26/wordpress-skeleton/) in 2012 which places WordPress core in a `/wp/` directory and then uses `/content/` instead of `/wp-content/`.  
	
	The  WordPress Skeleton layout works really well for Composer, but then **major WordPress managed hosts** _(such as [_WPEngine_](https://wpengine.com/))_ **only support hosting WordPress' default directly layout**, so that makes local development and then deployment a real challenge. 

	As an aside, we also have a WPLib project designed to streamline the build, test and deployment process too. We call it [_WP DevOps_](/wplib/wp-devops) and it currently works with [CircleCI](https://circleci.com/) for build and test with [Pantheon](https://pantheon.io/) or [WPEngine](https://wpengine.com/) for deployment. [**Check it out too**](/wplib/wp-devops)!



