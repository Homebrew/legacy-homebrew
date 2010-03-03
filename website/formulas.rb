require 'rubygems'
require 'sinatra'

$LOAD_PATH << File.join(File.dirname(__FILE__), "../Library/Homebrew")
$LOAD_PATH << File.join(File.dirname(__FILE__), "../Library/Formula")

require 'global'
require 'formula'

get '/' do
  body = "<ul>"
  Formulary.read_all do |name, klass|
    body << "<li><a href=\"/formula/#{name}\">#{name}</a></li>"
  end
  body << "</ul>"
end

get '/formula/:name' do
  klass = Formulary.read params[:name]
  body = "<h1>#{klass.to_s}</h1>"
  body << "<dl>"
  body << "<dt>Version</dt>"
  body << "<dd>#{klass.version}</dd>"
  body << "<dt>Homepage</dt>"
  body << "<dd><a href=\"#{klass.homepage}\">#{klass.homepage}</a></dd>"
  body << "<dt>Download</dt>"
  body << "<dd><a href=\"#{klass.url}\">#{klass.url}</a></dd>"
  body << "<dt>MD5</dt>"
  body << "<dd>#{klass.md5}</dd>"
  body << "</dl>"
end
