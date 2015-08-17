class GoAppEngine64 < Formula
  desc "Google App Engine SDK for Go!"
  homepage "https://cloud.google.com/appengine/docs/go/"
  url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-1.9.24.zip"
  sha256 "6a072ef4cdb0cc42d0b4a32494cbe1500d702208e345cef196b5878917df32f8"

  conflicts_with "go-app-engine-32", :because => "multiple conflicting files"
  conflicts_with "google-app-engine", :because => "multiple conflicting files"

  bottle do
    cellar :any
    sha256 "570879ba2f65c72dd6810f66634acaf4ab26490a1bba56abb7dc9af64b0a9246" => :yosemite
    sha256 "4cc613d80404728a2166458e07d2973c1330206229e4149aa4580fc9c83d4882" => :mavericks
    sha256 "532269adfd541ac1ac9c8d9828f2460af20ecb466f0993239001b782635c9940" => :mountain_lion
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
