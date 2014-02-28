require 'formula'

class GoAppEngine64 < Formula
  homepage 'http://code.google.com/appengine/docs/go/overview.html'
  url 'https://commondatastorage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-1.9.0.zip'
  sha1 '0e660230e4cfaac1b9dacff993d5128ef84c0fb9'

  def install
    cd '..'
    share.install 'go_appengine' => name
    bin.mkpath
    %w[
      api_server.py appcfg.py bulkloader.py bulkload_client.py dev_appserver.py download_appstats.py goapp
    ].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
