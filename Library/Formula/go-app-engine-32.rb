require 'formula'

class GoAppEngine32 < Formula
  homepage 'http://code.google.com/appengine/docs/go/overview.html'
  url 'http://googleappengine.googlecode.com/files/go_appengine_sdk_darwin_386-1.8.0.zip'
  sha1 '8a53c5e725516a12ebe06c8e84cce0d7d7b9ae48'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[
      api_server.py appcfg.py bulkloader.py bulkload_client.py dev_appserver.py download_appstats.py
    ].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
