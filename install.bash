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
# composer require symfony/yaml # in symfony/skeleton
# composer require symfony/console # in symfony/skeleton
/usr/bin/time composer require twig # symfony/twig-bundle
/usr/bin/time composer require server --dev # symfony/web-server-bundle
/usr/bin/time composer require css-selector # symfony/css-selector # Needed by a test!
/usr/bin/time composer require browser-kit # symfony/browser-kit
/usr/bin/time composer require simple-phpunit --dev # symfony/phpunit-bridge

bin/console assets:install --symlink
