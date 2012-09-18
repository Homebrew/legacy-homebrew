require 'formula'

class GoAppEngine64 < Formula
  homepage 'http://code.google.com/appengine/docs/go/overview.html'
  url 'http://googleappengine.googlecode.com/files/go_appengine_sdk_darwin_amd64-1.7.1.zip'
  sha1 '0fe70c356520cd8eec277a869198716000215d6c'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[
      appcfg.py bulkload_client.py bulkloader.py dev_appserver.py download_appstats.py
    ].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
