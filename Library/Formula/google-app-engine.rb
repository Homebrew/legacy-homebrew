require "formula"

class GoogleAppEngine < Formula
  desc "Google App Engine"
  homepage "https://developers.google.com/appengine/"
  url "https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.20.zip"
  sha256 "320e96b85405e8c6c9a8f1810f43cd3655b670cc4f49e0445eb7579da0498583"

  def install
    cd ".."
    share.install "google_appengine" => name
    %w[
      _python_runtime.py
      _php_runtime.py
      api_server.py
      appcfg.py
      bulkload_client.py
      bulkloader.py
      dev_appserver.py
      download_appstats.py
      endpointscfg.py
      gen_protorpc.py
      google_sql.py
      remote_api_shell.py
    ].each do |fn|
      bin.install_symlink share/name/fn
    end
  end
end
