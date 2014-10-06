require "formula"

class GoAppEngine64 < Formula
  homepage "http://code.google.com/appengine/docs/go/overview.html"

  if OS.mac?
    url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-1.9.12.zip"
    sha1 "19f8773e8ccb1d0d28c8475aa8d677eb54137580"
  elsif OS.linux?
    url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-1.9.12.zip"
    sha1 "400e43a1f8f600a41e9698108cdc9d0fbbf2aadb"
  else
    raise "Unknown operating system"
  end

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
