# Cookbook Name:: varnish
# Recipe:: default
# Author:: Joe Williams <joe@joetify.com>
# Author:: Tollef Fog Heen <tfheen@varnish-software.com>
#
# Copyright 2008-2009, Joe Williams
# Copyright 2011 Varnish Software AS
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

directory "/var/cache/chef"

if node[:platform] == "centos"
  s = "http://repo.varnish-cache.org/redhat/el5/noarch/varnish-release-2.1-2.noarch.rpm"
  p = "/var/cache/chef/varnish-release-2.1-2.noarch.rpm"

  remote_file p do
    source s
  end

  package "varnish-release" do
    provider Chef::Provider::Package::Rpm
    options "--nosignature"
    source p
  end
elsif node[:platform] in ["debian", "ubuntu"]

  a = cookbook_file "/etc/apt/trusted.gpg.d/Varnish.gpg" do
    mode "0644"
  end

  b = template "/etc/apt/sources.list.d/varnish-cache.list" do
    mode "0644"
    variables ({
                 :version => node[:varnish][:version],
                 :platform => node[:platform]
               })
  end

  a.run_action(:create)
  b.run_action(:create)

  package "varnish"
end

return
template "#{node[:varnish][:dir]}default.vcl" do
  source "default.vcl.erb"
  owner "root"
  group "root"
  mode 0644
end

template "#{node[:varnish][:default]}" do
  source "ubuntu-default.erb"
  owner "root"
  group "root"
  mode 0644
end

service "varnish" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end

service "varnishlog" do
  supports :restart => true, :reload => true
  action [ :enable, :start ]
end
