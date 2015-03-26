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

if ["centos","redhat"].include?(node[:platform])
  
  d = directory "/var/cache/chef"
  d.run_action(:create)
  
  a = template "/etc/yum.repos.d/varnish.repo" do
        cookbook "varnish"
        source "varnish.repo.erb" 
        owner "root"
        group "root"
        mode "0644"
        variables (:version => "varnish-#{node[:varnish][:version]}",
                   :el_version => "el#{node[:platform_version].split(".").first}" )
        action :nothing
      end
  b = yum_package "varnish" do
        flush_cache[:before]
        action :nothing
      end  
  a.run_action(:create)
  b.run_action(:install)

elsif ["debian", "ubuntu"].include?(node[:platform])

  a = cookbook_file "/etc/apt/trusted.gpg.d/Varnish.gpg" do
    mode "0644"
  end

  b = template "/etc/apt/sources.list.d/varnish-cache.list" do
    mode "0644"
    variables ({
                 :version => node[:varnish][:version],
                 :platform => node[:platform],
                 :codename => node[:lsb][:codename]
               })
  end

  a.run_action(:create)
  b.run_action(:create)

  package "varnish"

end

service "varnish" do
  supports :restart => true, :reload => true
  action [ :enable  ]
end

file "/etc/varnish/secret" do
  owner "root"
  group "root"
  mode "0600"
  content node[:varnish][:secret]
end

storage_spec = node[:varnish][:storage_spec]
if node[:varnish][:storage_spec] == "auto"
  use_mem = Integer(Integer(node[:memory][:total].scan(/\d+/)[0]) * 0.8)
  storage_spec = "malloc,#{use_mem}k"
end

template "#{node[:varnish][:default]}" do
  source "varnish-sysconfig.erb"
  owner "root"
  group "root"
  mode 0644
  variables({
              :vcl => "#{node[:varnish][:dir]}/default.vcl",
              :address => node[:varnish][:listen_address],
              :port => node[:varnish][:listen_port],
              :admin_address => node[:varnish][:admin_address],
              :admin_port => node[:varnish][:admin_port],
              :min_threads => node[:varnish][:min_threads],
              :max_threads => node[:varnish][:max_threads],
              :storage => storage_spec,
              :secret_file => "/etc/varnish/secret",
              :extra_parameters => node[:varnish][:parameters]
            })
  notifies :restart, resources(:service => "varnish")
end

if not node[:varnish][:remote_vcl].empty?
  remote_file "#{node[:varnish][:dir]}/default.vcl" do
    source node[:varnish][:remote_vcl]
    owner "root"
    group "root"
    mode 0644
    notifies :restart, resources(:service => "varnish")
  end

  file "/var/lib/varnish/vcl_url" do
    content node[:varnish][:remote_vcl]
  end
end

#service "varnishlog" do
#  supports :restart => true, :reload => true
#  action [ :enable, :start ]
#end
