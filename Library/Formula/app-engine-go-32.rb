class AppEngineGo32 < Formula
  desc "Google App Engine SDK for Go!"
  homepage "https://cloud.google.com/appengine/docs/go/"
  url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_386-1.9.27.zip"
  sha256 "90443fbcc24e3026b67d27241d7dfede7e380b9a0c6af737687360e7d9913d48"

  bottle :unneeded

  conflicts_with "go-app-engine-64", :because => "multiple conflicting files"
  conflicts_with "google-app-engine", :because => "multiple conflicting files"

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
