require 'formula'

class GoAppEngine64 < Formula
  homepage 'http://code.google.com/appengine/docs/go/overview.html'
  url 'http://googleappengine.googlecode.com/files/go_appengine_sdk_darwin_amd64-1.8.6.zip'
  sha1 'ca7c50daf3ddcd8e0a1ef975c2455f667048b56d'

  def install
    cd '..'
    share.install 'go_appengine' => name
    bin.mkpath
    %w[
      api_server.py appcfg.py bulkloader.py bulkload_client.py dev_appserver.py download_appstats.py
    ].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
