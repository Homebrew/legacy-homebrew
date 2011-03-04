require 'formula'

class GoogleAppEngine <Formula
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.4.0.zip'
  homepage 'http://code.google.com/appengine/'
  sha1 '8b5bac0ba85e98160fa0fada0c3e957326732947'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
