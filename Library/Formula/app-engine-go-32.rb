class AppEngineGo32 < Formula
  desc "Google App Engine SDK for Go (i386)"
  homepage "https://cloud.google.com/appengine/docs/go/"
  url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_386-1.9.30.zip"
  sha256 "15d7f5f378d6e765da22c5db7ff855dafee1c2f72c78347bc9a1e4426248f2e3"

  bottle :unneeded

  conflicts_with "app-engine-go-64",
    :because => "both install the same binaries"
  conflicts_with "app-engine-python",
    :because => "both install the same binaries"

  def install
    share.install Dir["*"]
    %w[
      api_server.py appcfg.py bulkloader.py bulkload_client.py dev_appserver.py download_appstats.py goapp
    ].each do |fn|
      bin.install_symlink share/fn
    end
  end

  test do
    assert_match(/^usage: goapp serve/, shell_output("#{bin}/goapp help serve").strip)
  end
end
