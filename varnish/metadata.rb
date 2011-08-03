maintainer        "Varnish Software"
maintainer_email  "tfheen@varnish-software.com"
license           "Apache 2.0"
description       "Installs and configures varnish"
version           "0.7"

%w{ubuntu debian centos}.each do |os|
  supports os
end

provides "varnish::default"
recipe "varnish::default", "Install and configure Varnish Cache"

attribute 'varnish/version',
:display_name => "Varnish version",
:description => "What version of Varnish to install",
:choice => [ '2.1', '3.0' ],
:type => "string",
:recipes => [ 'varnish::default' ],
:default => "3.0"

attribute 'varnish/listen_address',
:display_name => "Address to listen on for HTTP traffic",
:description => "What address Varnish should listen on. Blank means all IP addresses",
:type => "string",
:required => "optional",
:recipes => [ 'varnish::default' ],
:default => ""

attribute 'varnish/listen_port',
:display_name => "Port to listen on for HTTP traffic",
:description => "Any extra command line parameters for Varnish",
:type => "string",
:required => "optional",
:recipes => [ 'varnish::default' ],
:default => "80"

attribute 'varnish/admin_address',
:display_name => "Administrative interface address",
:description => "What address Varnish should listen on for administrative connections. Blank means all IP addresses",
:type => "string",
:required => "optional",
:recipes => [ 'varnish::default' ],
:default => ""

attribute 'varnish/admin_port',
:display_name => "Administrative interface port",
:description => "What port the administrative port should run on.",
:type => "string",
:required => "optional",
:recipes => [ 'varnish::default' ],
:default => ""

attribute 'varnish/min_threads',
:display_name => "Minimum number of threads",
:description => "The minimum number of threads Varnish should run with",
:type => "string",
:required => "recommended",
:recipes => [ 'varnish::default' ],
:default => "10"

attribute 'varnish/max_threads',
:display_name => "Maximum number of threads",
:description => "The minimum number of threads Varnish should use",
:type => "string",
:required => "recommended",
:recipes => [ 'varnish::default' ],
:default => "1000"

attribute 'varnish/storage_spec',
:display_name => "Storage specification",
:description => "What storage and sizing information",
:type => "string",
:required => "recommended",
:recipes => [ 'varnish::default' ],
:default => "auto"

attribute 'varnish/secret',
:display_name => "Authentication secret",
:description => "This is a random string used for authenticating with Varnish",
:type => "string",
:required => "required",
:recipes => [ 'varnish::default' ]

attribute 'varnish/parameters',
:display_name => "Extra  parameters",
:description => "Any extra command line parameters for Varnish",
:type => "string",
:required => "optional",
:recipes => [ 'varnish::default' ],
:default => ""

attribute 'varnish/remote_vcl',
:display_name => "VCL URL",
:description => "Where to fetch the VCL from.",
:type => "string",
:required => "optional",
:recipes => [ 'varnish::default' ],
:default => ""
