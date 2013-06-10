module MCollective
    module Agent 
        # Inspired with the agent meta.rb of R.I.Pienaar
        class Sleep<RPC::Agent
            metadata :name        => "Sleep",
                     :description => "Just Sleeps",
                     :author      => "Louis Coilliot",
                     :license     => "",
                     :version     => "1.0",
                     :url         => "http://kermit.fr",
                     :timeout     => 600

            action "sleepy" do
                validate :seconds, String 
                reply.data = { :slept_s => sleep(request[:seconds].to_i) }        
            end
        end
    end
end
