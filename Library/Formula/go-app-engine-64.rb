require "formula"

class GoAppEngine64 < Formula
  homepage "http://code.google.com/appengine/docs/go/overview.html"
  url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-1.9.10.zip"
  sha1 "bbf5852a348000cdca128c2f5465691232001f33"

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
