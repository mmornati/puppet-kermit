metadata :name        => "SimpleRPC Sample Agent",
         :description => "Echo service for MCollective",
         :author      => "R.I.Pienaar",
         :license     => "GPLv2",
         :version     => "1.1",
         :url         => "http://projects.puppetlabs.com/projects/mcollective-plugins/wiki",
         :timeout     => 60

action "echo", :description => "just sends the msg of any request back" do
    display :always

    input :msg,
    :prompt      => "Message",
    :description => "message",
    :validation  => '^[a-zA-Z\-_\d]+$', 
    :type        => :string,
    :optional    => false,
    :maxlength   => 40

end
