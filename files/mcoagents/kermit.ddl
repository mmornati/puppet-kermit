metadata :name        => "Kermit",
         :description => "Maintenance tasks for Kermit",
         :author      => "Louis Coilliot",
         :license     => "GPLv3",
         :version     => "1.0",
         :url         => "http://www.kermit.fr",
         :timeout     => 60

action "clean", :description => "Some cleaning" do
    display :always
end
