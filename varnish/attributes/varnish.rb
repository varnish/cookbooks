case platform
when "debian","ubuntu"
  set[:varnish][:dir]     = "/etc/varnish"
  set[:varnish][:default] = "/etc/default/varnish"
when "centos"
  set[:varnish][:dir]     = "/etc/varnish"
  set[:varnish][:default] = "/etc/sysconfig/varnish"
end

default[:varnish][:version] = "2.1"
