require 'resque/server'
require 'activejob-status'

module Resque
  module ActiveJobStatusServer

    VIEW_PATH = File.join(File.dirname(__FILE__), 'resque-server', 'views')
    PER_PAGE = 50

    def self.registered(app)

      app.get '/activejob' do
        # @start = params[:start].to_i
        # @end = @start + (params[:per_page] || per_page) - 1
        # @statuses = Resque::Plugins::Status::Hash.statuses(@start, @end)
        # @size = Resque::Plugins::Status::Hash.count
        status_view(:statuses)
      end



      app.helpers do
        def per_page
          PER_PAGE
        end

        def status_view(filename, options = {}, locals = {})
          erb(File.read(File.join(::Resque::ActiveJobStatusServer::VIEW_PATH, "#{filename}.erb")), options, locals)
        end

        def status_poll(start)
          if @polling
            text = "Last Updated: #{Time.now.strftime("%H:%M:%S")}"
          else
            text = "<a href='#{u(request.path_info)}.poll?start=#{start}' rel='poll'>Live Poll</a>"
          end
          "<p class='poll'>#{text}</p>"
        end
      end

      app.tabs << "ActiveJob"

    end

  end
end

Resque::Server.register Resque::ActiveJobStatusServer
