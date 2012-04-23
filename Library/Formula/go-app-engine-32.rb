require 'formula'

class GoAppEngine32 < Formula
  url 'http://googleappengine.googlecode.com/files/go_appengine_sdk_darwin_386-1.6.4.zip'
  homepage 'http://code.google.com/appengine/docs/go/overview.html'
  sha1 'abd30c1f1c03dc8a673e0d3c285e1b11b78e782a'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
