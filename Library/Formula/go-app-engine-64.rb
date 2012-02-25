require 'formula'

class GoAppEngine64 < Formula
  url 'http://googleappengine.googlecode.com/files/go_appengine_sdk_darwin_amd64-1.6.2.zip'
  homepage 'http://code.google.com/appengine/docs/go/overview.html'
  sha1 '5415b2c6104834ae1a9abf68c0257a78d2065d0e'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
