require 'formula'

class GoAppEngine64 < Formula
  homepage 'http://code.google.com/appengine/docs/go/overview.html'
  url 'http://googleappengine.googlecode.com/files/go_appengine_sdk_darwin_amd64-1.7.0.zip'
  sha1 '6d971bd9ce86db04268a7da155222c771a62934a'

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
