require 'formula'

class GoAppEngine32 < Formula
  homepage 'http://code.google.com/appengine/docs/go/overview.html'
  url 'http://googleappengine.googlecode.com/files/go_appengine_sdk_darwin_386-1.7.0.zip'
  sha1 '8381e11efa6629b5836b20cabf7bc3224976f454'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[
      appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py
    ].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
