require 'formula'

class GoAppEngine64 < Formula
  url 'http://googleappengine.googlecode.com/files/go_appengine_sdk_darwin_amd64-1.6.4.zip'
  homepage 'http://code.google.com/appengine/docs/go/overview.html'
  sha1 '5de646a1d400c191a7227f58098de090926727ea'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
