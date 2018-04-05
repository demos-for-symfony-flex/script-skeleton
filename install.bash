#!/bin/bash
# [[ ]] requires bash
set -ev # https://docs.travis-ci.com/user/customizing-the-build/

origin=$(pwd)
composer create-project --no-install symfony/skeleton $CREATE_PROJECT_DIRECTORY
if [[ -v $CREATE_PROJECT_DIRECTORY ]]; then
  cd $CREATE_PROJECT_DIRECTORY
else
  cd website-skeleton
fi
composer config bin-dir bin
# cp $origin/.env.dist . # Needs apparently to be done before install.
composer install
echo "sensio/framework-extra-bundle"
composer require annotations # sensio/framework-extra-bundle
# composer remove --dev symfony/profiler-pack
#^ Dependency "symfony/twig-bundle" is also a root requirement, but is not explicitly whitelisted. Ignoring.
# install --directory config # Is it really needed?
# composer require symfony/yaml # in symfony/skeleton
# composer require symfony/console # in symfony/skeleton
echo "symfony/twig-bundle"
composer require twig # in symfony/website-skeleton
## composer require sensio/framework-extra-bundle # in symfony/website-skeleton
# composer require symfony/orm-pack # in symfony/website-skeleton
# composer require symfony/swiftmailer-bundle # in symfony/website-skeleton
# composer require symfony/security-csrf
# cp $origin/config/packages/*.yaml config/packages --verbose
# cp $origin/config/routes/*.yaml config/routes --verbose
# composer require friendsofsymfony/user-bundle
echo "symfony/phpunit-bridge"
composer require simple-phpunit

# cp $origin/src/Entity/*.php src/Entity --verbose # May be done earlier.
# bin/console doctrine:database:create
# bin/console doctrine:migrations:diff --quiet
# bin/console doctrine:migrations:migrate --no-interaction --quiet
# bin/console doctrine:schema:update --force
# composer require doctrine/doctrine-fixtures-bundle --dev
# cp $origin/src/DataFixtures/AppFixtures.php src/DataFixtures
# bin/console doctrine:fixtures:load --append
# bin/console fos:user:create superadmin superadmin@example.com superadmin --super-admin
# bin/console fos:user:create user user@example.com user

cp --recursive $origin/tests . --verbose

bin/console assets:install --symlink
