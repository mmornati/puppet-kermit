module MCollective
    module Agent
        class Helloworld<RPC::Agent
            # Basic echo server
            action "echo" do
                validate :msg, String

                reply.data = request[:msg]
            end
        end
    end
end
# vi:tabstop=4:expandtab:ai
