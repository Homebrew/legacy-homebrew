require 'formula'

class GoAppEngine64 < Formula
  homepage 'http://code.google.com/appengine/docs/go/overview.html'
  url 'https://commondatastorage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-1.9.4.zip'
  sha1 'b5f85c0ecfd542cc4fc2b1c9ed4a0dc2117cc088'

  def install
    cd '..'
    share.install 'go_appengine' => name
    %w[
      api_server.py appcfg.py bulkloader.py bulkload_client.py dev_appserver.py download_appstats.py goapp
    ].each do |fn|
      bin.install_symlink share/name/fn
    end
  end
end
