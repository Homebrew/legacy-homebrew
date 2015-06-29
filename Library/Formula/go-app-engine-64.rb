require "formula"

class GoAppEngine64 < Formula
  desc "Google App Engine SDK for Go!"
  homepage "https://cloud.google.com/appengine/docs/go/"
  if OS.mac?
    url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-1.9.23.zip"
    sha256 "4eb357055f5c4d2ddc95253b6613ddeb5459dfa17c247ad0ba44f930d47096db"
  elsif OS.linux?
    url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-1.9.23.zip"
    sha256 "d1a0caf17f36bff3d108926f5f9bf4a3872648ad5c985728c837c0c9e8ffa6c0"
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
