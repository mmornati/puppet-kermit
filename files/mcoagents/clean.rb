require 'fileutils'

module MCollective
    module Agent
        class Clean<RPC::Agent

            action "logs" do
                clean_logs
                reply.data = 'Cleaned'
            end

            action "filebucket" do
                clean_filebucket
                reply.data = 'Cleaned'
            end

            action "all" do
                clean_logs
                clean_filebucket
                reply.data = 'Cleaned'
            end

            private

            def clean(globs)
                globs.each do |g|
                    FileUtils.rm_r(Dir.glob(g),
                         :force => true, :secure => true)
                end
            end

            def clean_logs
                myglobs = [ '/var/log/**/*20*',
                            '/var/log/**/*.gz',
                            '/var/log/**/*.[0-9]' ]
                clean(myglobs)
            end

            def clean_filebucket
                myglobs = [ '/var/lib/puppet/clientbucket/*' ]
                clean(myglobs)
            end

        end
    end
end
# vi:tabstop=4:expandtab:ai
