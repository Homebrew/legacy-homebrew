require 'formula'

class GoogleAppEngine < Formula
  homepage 'http://code.google.com/appengine/'
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.6.6.zip'
  sha1 'd0b4934f295cc3be0a55840b5551d56548b611dd'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
