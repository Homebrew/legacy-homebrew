require 'formula'

class GoogleAppEngine <Formula
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.2.7.zip'
  homepage 'appengine.google.com'
  md5 'b71a437d2d78fb558c2f529ccb3ffb40'

  def install
    cd '..'
    mkdir share
    mv 'google_appengine', share+name
    mkdir bin
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin+fn
    end
  end
end
