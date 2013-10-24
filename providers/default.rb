action :stop do
  service "varnish" do
    action :stop
  end
end

action :start do
  service "varnish" do
    action :start
  end
end

action :restart do
  service "varnish" do
    action :restart
  end
end

action :reload do
  service "varnish" do
    action :reload
  end
end

