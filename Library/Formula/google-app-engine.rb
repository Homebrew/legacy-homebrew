require "formula"

class GoogleAppEngine < Formula
  homepage "https://developers.google.com/appengine/"
  url "https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.18.zip"
  sha256 "2da5885015909de1ede69bf4bdaae143f19b35f4d6f32c73415ebfd246a1ca05"

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
