require 'formula'

class GoogleAppEngine < Formula
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.5.4.zip'
  homepage 'http://code.google.com/appengine/'
  sha1 '0c580fa233527dd701d9363eebc8ee0a7fe8dd95'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
