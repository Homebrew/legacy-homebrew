require 'formula'

class GoAppEngine64 < Formula
  homepage 'http://code.google.com/appengine/docs/go/overview.html'
  url 'http://googleappengine.googlecode.com/files/go_appengine_sdk_darwin_amd64-1.8.8.zip'
  sha1 '8933c5bfd25811cae2e863a0c071812607a66f3e'

  def install
    cd '..'
    share.install 'go_appengine' => name
    bin.mkpath
    %w[
      api_server.py appcfg.py bulkloader.py bulkload_client.py dev_appserver.py download_appstats.py goapp
    ].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
