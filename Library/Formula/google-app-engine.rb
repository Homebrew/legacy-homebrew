require 'formula'

class GoogleAppEngine < Formula
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.5.5.zip'
  homepage 'http://code.google.com/appengine/'
  sha1 'e71bbbf185b746822b19d9c4eafe995a772fc993'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
