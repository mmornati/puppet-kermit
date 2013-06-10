require 'fileutils'

module MCollective
    module Agent
        class Kermit<RPC::Agent
            action "clean" do
                myglobs = [
                  '/tmp/sched/*',
                  '/tmp/*inventory*.json',
                  '/tmp/server.log*',
                  '/var/lib/kermit/queue/kermit.inventory/*',
                  '/var/lib/kermit/queue/kermit.log/*',
                  '/var/log/mcollective.log.*' ]

                myglobs.each do |g|
                    FileUtils.rm_r(Dir.glob(g),
                         :force => false, :secure => true)
                end
                reply.data = 'Cleaned' 
            end
        end
    end
end
# vi:tabstop=4:expandtab:ai
