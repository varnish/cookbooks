maintainer        "Varnish Software"
maintainer_email  "tfheen@varnish-software.com"
license           "Apache 2.0"
description       "Installs and configures varnish"
version           "0.7"

%w{ubuntu debian centos}.each do |os|
  supports os
end
