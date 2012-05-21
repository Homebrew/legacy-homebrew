require 'formula'

class GoogleAppEngine < Formula
  homepage 'http://code.google.com/appengine/'
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.6.5.zip'
  sha1 '4e79009803db6893adc349c6a37211a72a883a8e'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
