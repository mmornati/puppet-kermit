metadata :name        => "Clean",
         :description => "Maintenance tasks for test VMs",
         :author      => "Louis Coilliot",
         :license     => "GPLv3",
         :version     => "1.0",
         :url         => "http://www.kermit.fr",
         :timeout     => 60

action "logs", :description => "Clean logs" do
    display :always
end

action "filebucket", :description => "Clean Puppet filebucket" do
    display :always
end

action "all", :description => "Clean all" do
    display :always
end
