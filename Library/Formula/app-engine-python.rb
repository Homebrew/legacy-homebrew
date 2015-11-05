class AppEnginePython < Formula
  desc "Google App Engine"
  homepage "https://cloud.google.com/appengine/docs"
  url "https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.27.zip"
  sha256 "6192f295969dabf8659ce9a698450154f7c8c35b89c6e3cb52908c8f50d7c1f4"

  bottle :unneeded

  conflicts_with "app-engine-go-32",
    :because => "both install the same binaries"
  conflicts_with "app-engine-go-64",
    :because => "both install the same binaries"

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
