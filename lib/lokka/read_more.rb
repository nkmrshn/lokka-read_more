module Lokka
  module ReadMore
    def self.registered(app)
      app.get '/admin/plugins/read_more' do
        haml :"plugin/lokka-read_more/views/index", :layout => :"admin/layout"
      end 

      app.put '/admin/plugins/read_more' do
        Option.read_more_delimiter = params['delimiter']
        flash[:notice] = t.read_more_updated
        redirect '/admin/plugins/read_more'
      end 
    end
  end

  module Helpers
    def body_with_more(o)
      delimiter = (Option.read_more_delimiter || "----") + "<br>"
      unless (i = o.body.index(delimiter)).nil?
        body = o.body.slice(0, i)
        if @request.env['PATH_INFO'] == '/'
          body += %Q(<a href="/#{o.id}">#{t.read_more}</a>)
        else
          body += o.body.slice(i + delimiter.length, o.body.length) 
        end
      else
        o.body
      end
    end
  end
end
