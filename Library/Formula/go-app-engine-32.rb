require "formula"

class GoAppEngine32 < Formula
  homepage "http://code.google.com/appengine/docs/go/overview.html"
  url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_386-1.9.8.zip"
  sha1 "3768e768b1694ab16968a793b07a4f6d58ea4010"

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
