#!/bin/bash
# [[ ]] requires bash
set -ev # https://docs.travis-ci.com/user/customizing-the-build/

if [[ -v $CREATE_PROJECT_DIRECTORY ]]; then
  echo "CREATE_PROJECT_DIRECTORY"
  printenv CREATE_PROJECT_DIRECTORY
else
  echo "Using skeleton directory..."
fi

origin=$(pwd)
/usr/bin/time composer create-project --no-install symfony/skeleton $CREATE_PROJECT_DIRECTORY
if [[ -v $CREATE_PROJECT_DIRECTORY ]]; then
  cd $CREATE_PROJECT_DIRECTORY
else
  cd skeleton
fi
(cd $origin && tar --exclude-vcs --create --file - .) | tar --extract --verbose --file -
composer config bin-dir bin
# cp $origin/.env.dist . # Needs apparently to be done before install.

/usr/bin/time composer install

/usr/bin/time composer require annotations # sensio/framework-extra-bundle
# temorary bug in Symfony 4.1 sensio/framework-extra-bundle 5.2
# http://symfony.com/doc/current/bundles/SensioFrameworkExtraBundle
# [How to fix Symfony 3.4 @Route and @Method deprecation](https://stackoverflow.com/questions/51171934/how-to-fix-symfony-3-4-route-and-method-deprecation)
# [Symfony: Deprecated @Route and @Method Annotations](https://medium.com/@nebkam/symfony-deprecated-route-and-method-annotations-4d5e1d34556a)

# composer require symfony/yaml # in symfony/skeleton
# composer require symfony/console # in symfony/skeleton
/usr/bin/time composer require twig # symfony/twig-bundle
/usr/bin/time composer require server --dev # symfony/web-server-bundle
/usr/bin/time composer require css-selector --dev # symfony/css-selector # Needed by a test!
/usr/bin/time composer require browser-kit --dev # symfony/browser-kit
/usr/bin/time composer require simple-phpunit --dev # symfony/phpunit-bridge

bin/console assets:install --symlink
