class AppEnginePython < Formula
  desc "Google App Engine"
  homepage "https://cloud.google.com/appengine/docs"
  url "https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.26.zip"
  sha256 "96eb9d7db8eb11275fc67a8afc21d9315bcb50d571b29e126b60ba1a466ebbb8"

  conflicts_with "go-app-engine-32", :because => "multiple conflicting files"
  conflicts_with "go-app-engine-64", :because => "multiple conflicting files"

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
