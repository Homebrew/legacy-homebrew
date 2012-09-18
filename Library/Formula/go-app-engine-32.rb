require 'formula'

class GoAppEngine32 < Formula
  homepage 'http://code.google.com/appengine/docs/go/overview.html'
  url 'http://googleappengine.googlecode.com/files/go_appengine_sdk_darwin_386-1.7.1.zip'
  sha1 'f55848605ba5892e968c65712449fabba5dbccbc'

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
