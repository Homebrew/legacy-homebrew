require 'formula'

class GoogleAppEngine <Formula
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.3.1.zip'
  homepage 'http://code.google.com/appengine/'
  md5 '5836be82d01826f34fea1b0193cb62bf'

  def install
    cd '..'
    share.install 'google_appengine' => name
    mkdir bin
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin+fn
    end
  end
end
