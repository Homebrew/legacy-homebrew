require 'formula'

class GoogleAppEngine < Formula
  url 'http://googleappengine.googlecode.com/files/go_appengine_sdk_darwin_amd64-1.5.0.zip'
  homepage 'http://code.google.com/appengine/'
  sha1 'f7f5c4931d184fafbe9de71f381aca9bc1bd000b'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
