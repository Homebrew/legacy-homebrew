require 'formula'

class GoogleAppEngine < Formula
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.5.2.zip'
  homepage 'http://code.google.com/appengine/'
  sha1 'a9457232bc7aa9316ce03d64bb12bbe2a9d3ef8a'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
