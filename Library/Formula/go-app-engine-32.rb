require "formula"

class GoAppEngine32 < Formula
  homepage "https://cloud.google.com/appengine/docs/go/"
  url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_386-1.9.18.zip"
  sha1 "5f74eba1b77dddca9122ba355e6348e8cc833031"

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
