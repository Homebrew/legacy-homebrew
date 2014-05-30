require 'formula'

class GoAppEngine32 < Formula
  homepage 'http://code.google.com/appengine/docs/go/overview.html'
  url 'https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_386-1.9.5.zip'
  sha1 '95e8ea9c4cdc5f4feea2b2e1fdb90d9f259eb774'

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
