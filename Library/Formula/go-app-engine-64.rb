require "formula"

class GoAppEngine64 < Formula
  homepage "http://code.google.com/appengine/docs/go/overview.html"

  if OS.mac?
    url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-1.9.15.zip"
    sha1 "de638e484af2e6d94f5a8cbdc24a7b9c791c6531"
  elsif OS.linux?
    url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-1.9.15.zip"
    sha1 "5677d7cc2a060458f5703db336faa220b110a8b6"
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
