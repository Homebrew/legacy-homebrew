require 'formula'

class GoogleAppEngine < Formula
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.6.2.zip'
  homepage 'http://code.google.com/appengine/'
  sha1 '7fd3ae37bc76b0ffcbb14a7b2e404559ec18b551'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
