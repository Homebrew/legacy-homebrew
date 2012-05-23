require 'formula'

class GoAppEngine64 < Formula
  url 'http://googleappengine.googlecode.com/files/go_appengine_sdk_darwin_amd64-1.6.6.zip'
  homepage 'http://code.google.com/appengine/docs/go/overview.html'
  sha1 '61996f3c5912508933ccc2aa4f3400fbdb0d37e8'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py download_appstats.py].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
