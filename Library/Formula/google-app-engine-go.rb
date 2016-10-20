require 'formula'

class GoogleAppEngineGo < Formula
  url 'http://googleappengine.googlecode.com/files/go_appengine_sdk_darwin_amd64-1.5.1.zip'
  homepage 'http://code.google.com/appengine/downloads.html#Google_App_Engine_SDK_for_Go'
  md5 '7abaf8f6fc51888a18bbf24d88f515ab'

  def install
      cd '..'
      share.install 'google_appengine' => name
      bin.mkpath
      %w[appcfg.py bulkload_client.py bulkloader.py dev_appserver.py remote_api_shell.py].each do |fn|
          ln_s share+name+fn, bin
      end
  end
end
