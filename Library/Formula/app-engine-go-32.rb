class AppEngineGo32 < Formula
  desc "Google App Engine SDK for Go (i386)"
  homepage "https://cloud.google.com/appengine/docs/go/"
  url "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_386-1.9.31.zip"
  sha256 "4e47b4a97eae754ddf33a4ad407a594ee78b301d2bf9c239356b24f96662759f"

  bottle :unneeded

  conflicts_with "app-engine-go-64",
    :because => "both install the same binaries"
  conflicts_with "app-engine-python",
    :because => "both install the same binaries"

  def install
    pkgshare.install Dir["*"]
    %w[
      api_server.py appcfg.py bulkloader.py bulkload_client.py dev_appserver.py download_appstats.py goapp
    ].each do |fn|
      bin.install_symlink pkgshare/fn
    end
  end

  test do
    assert_match(/^usage: goapp serve/, shell_output("#{bin}/goapp help serve").strip)
  end
end
