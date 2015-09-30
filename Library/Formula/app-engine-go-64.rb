class AppEngineGo64 < Formula
  desc "Google App Engine SDK for Go!"
  homepage "https://cloud.google.com/appengine/docs/go/"
  url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-1.9.26.zip"
  sha256 "ae3648c4df3a20acad4207493586a90214a50b6ca1edb887ae4ca062bbd7a7e5"

  conflicts_with "go-app-engine-32", :because => "multiple conflicting files"
  conflicts_with "google-app-engine", :because => "multiple conflicting files"

  bottle do
    cellar :any_skip_relocation
    sha256 "d91f0fe524e9c95e949d55b4527c980c1de7a63dce1bac22de56d9401e3cdacc" => :el_capitan
    sha256 "e94cbf02fd1a1ffa759787d9d157ddd3ee9182ea4abf27e30d90e766556f69cb" => :yosemite
    sha256 "6094c41c3c019bc0a23282b3c7bf6ad7ca3edd9fefaabeddb83f2101ec2fd5a6" => :mavericks
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
