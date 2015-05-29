require "formula"

class GoAppEngine64 < Formula
  homepage "https://cloud.google.com/appengine/docs/go/"
  if OS.mac?
    url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-1.9.20.zip"
    sha1 "2e95dd9176187503f9665b2ffabb93367e61474f"
  elsif OS.linux?
    url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-1.9.20.zip"
    sha256 "fcbd41f76bac346ebcf3eefa22bf77015a47bb93f638a51a9d492b5bc49bedc2"
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
