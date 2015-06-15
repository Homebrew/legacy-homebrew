require "formula"

class GoAppEngine64 < Formula
  desc "Google App Engine SDK for Go!"
  homepage "https://cloud.google.com/appengine/docs/go/"
  if OS.mac?
    url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-1.9.21.zip"
    sha1 "ffe246b8fe26e290d86a0cca4581a16088e58d5e"
  elsif OS.linux?
    url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-1.9.21.zip"
    sha256 "9609f09fe2bd3f0575ae59b02b5e0984a8ccce0ffd95863ce5a7c85f9cfb46ec"
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
