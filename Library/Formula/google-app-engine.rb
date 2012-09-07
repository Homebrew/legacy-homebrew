require 'formula'

class GoogleAppEngine < Formula
  homepage 'http://code.google.com/appengine/'
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.7.1.zip'
  sha1 '1b41e08beb183affac7867bf78153b3389b9fd2a'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
