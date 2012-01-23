require 'formula'

class GoogleAppEngine < Formula
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.6.0.zip'
  homepage 'http://code.google.com/appengine/'
  sha1 '7aea5badeb96861c7b445ff72700e418ef361ac5'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
