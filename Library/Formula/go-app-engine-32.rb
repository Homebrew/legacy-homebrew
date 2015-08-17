class GoAppEngine32 < Formula
  desc "Google App Engine SDK for Go!"
  homepage "https://cloud.google.com/appengine/docs/go/"
  url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_386-1.9.23.zip"
  sha256 "01271376dd0f04e1ff3bc52d71f2a933b4add478a6c9e8ca3b2de3468327b561"

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
