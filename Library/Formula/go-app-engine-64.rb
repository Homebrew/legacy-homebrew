require "formula"

class GoAppEngine64 < Formula
  homepage "http://code.google.com/appengine/docs/go/overview.html"
  url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-1.9.8.zip"
  sha1 "f7db53a6f0ebdf7beb7a1818672e048bce3faf47"

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
