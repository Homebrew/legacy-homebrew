require "formula"

class GoAppEngine32 < Formula
  homepage "http://code.google.com/appengine/docs/go/overview.html"
  url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_386-1.9.14.zip"
  sha1 "f4d33004560ead1812603494ea9db04997476850"

  def install
    cd ".."
    share.install "go_appengine" => name
    %w[
      api_server.py appcfg.py bulkloader.py bulkload_client.py dev_appserver.py download_appstats.py goapp
    ].each do |fn|
      bin.install_symlink share/name/fn
    end
  end
end
