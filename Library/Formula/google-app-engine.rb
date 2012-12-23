require 'formula'

class GoogleAppEngine < Formula
  homepage 'https://developers.google.com/appengine/'
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.7.4.zip'
  sha1 '05eaddb534e3cb1d002cdaa529ff75ef36a30026'

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
