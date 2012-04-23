require 'formula'

class GoogleAppEngine < Formula
  homepage 'http://code.google.com/appengine/'
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.6.4.zip'
  sha1 '72b5bf9a61d5c3b1dff591f3cf313dc0e80a31da'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
