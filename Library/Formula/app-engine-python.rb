class AppEnginePython < Formula
  desc "Google App Engine"
  homepage "https://cloud.google.com/appengine/docs"
  url "https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.32.zip"
  sha256 "e0e5fc32731ebaae26be43c662330ebb5228d202dd622d7da18c5e9e6fedc37b"

  bottle :unneeded

  conflicts_with "app-engine-go-32",
    :because => "both install the same binaries"
  conflicts_with "app-engine-go-64",
    :because => "both install the same binaries"

  def install
    pkgshare.install Dir["*"]
    %w[
      _python_runtime.py
      _php_runtime.py
      api_server.py
      appcfg.py
      backends_conversion.py
      bulkload_client.py
      bulkloader.py
      dev_appserver.py
      download_appstats.py
      endpointscfg.py
      gen_protorpc.py
      google_sql.py
      php_cli.py
      remote_api_shell.py
      run_tests.py
      wrapper_util.py
    ].each do |fn|
      bin.install_symlink share/name/fn
    end
  end
end
