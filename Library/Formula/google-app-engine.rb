require 'formula'

class GoogleAppEngine < Formula
  homepage 'https://developers.google.com/appengine/'
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.7.3.zip'
  sha1 'f0dec97a80c5dd0184b7e3fa6e44850ee139b0fa'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[
      api_server.py appcfg.py bulkloader.py bulkload_client.py dev_appserver.py download_appstats.py remote_api_shell.py
    ].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
