class AppEngineGo64 < Formula
  desc "Google App Engine SDK for Go!"
  homepage "https://cloud.google.com/appengine/docs/go/"
  url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-1.9.27.zip"
  sha256 "a719e8f5ef23eab2a18980a49a79f570cf64ee519f8abdbf9643731900300488"

  conflicts_with "go-app-engine-32", :because => "multiple conflicting files"
  conflicts_with "google-app-engine", :because => "multiple conflicting files"

  bottle :unneeded

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
