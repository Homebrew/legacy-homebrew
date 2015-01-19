require "formula"

class GoAppEngine64 < Formula
  homepage "https://code.google.com/appengine/docs/go/overview.html"

  if OS.mac?
    url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-1.9.17.zip"
    sha1 "c88aa3e50f56f8c1b3d27cdaee68d2c17ac4ed22"
  elsif OS.linux?
    url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-1.9.17.zip"
    sha1 "bdcf47c48b6e099a6596f9124fc29988dd4b874f"
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
