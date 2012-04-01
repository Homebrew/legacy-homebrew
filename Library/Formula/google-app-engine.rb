require 'formula'

class GoogleAppEngine < Formula
  homepage 'http://code.google.com/appengine/'
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.6.3.zip'
  sha1 '0f57de7ff445872f85d6dc5192ed4d5c89c8aef6'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
