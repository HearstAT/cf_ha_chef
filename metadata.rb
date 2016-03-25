name 'cf_ha_chef'
maintainer 'Hearst Automation Team'
maintainer_email 'atat@hearst.com'
license 'MIT'
description 'Installs/Configures cf_ha_chef'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.1'

depends 'lvm'
depends 'python'
depends 'citadel'
depends 'newrelic'
depends 'newrelic_meetme_plugin'
depends 'sumologic-collector'
