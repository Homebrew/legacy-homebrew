require 'formula'

class GoogleAppEngine <Formula
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.3.2.zip'
  homepage 'http://code.google.com/appengine/'
  sha1 '9390f8250ef4d7acdf7ff42a7eab8f3646ade9f6'

  def install
    cd '..'
    share.install 'google_appengine' => name
    mkdir bin
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin+fn
    end
  end
end
