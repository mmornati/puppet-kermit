metadata     :name    => "Sleep",
             :description => "Just sleeps",
             :author      => "Louis Coilliot",
             :license     => "GPLv3",
             :version     => "1.0",
             :url         => "http://kermit.fr",
             :timeout     => 600


action "sleepy", :description => "Sleeps" do
    display :always

    input :seconds,
    :prompt      => "Number of seconds",
    :description => "seconds",
    :validation  => '^[\d]+$',
    :type        => :string,
    :optional    => false,
    :maxlength   => 3

    output :slept_s,
           :description => 'Time slept in seconds',
           :display_as  => "Time slept (s)"
end
