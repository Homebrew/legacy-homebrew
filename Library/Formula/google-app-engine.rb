require 'formula'

class GoogleAppEngine < Formula
  homepage 'https://developers.google.com/appengine/'
  url 'http://googleappengine.googlecode.com/files/google_appengine_1.7.6.zip'
  sha1 'ad0314ea745ccf581e8df5c8eeb76e582a0a30f2'

  def install
    cd '..'
    share.install 'google_appengine' => name
    bin.mkpath
    %w[
      api_server.py appcfg.py bulkload_client.py bulkloader.py dev_appserver.py download_appstats.py endpointscfg.py gen_protorpc.py google_sql.py old_dev_appserver.py remote_api_shell.py
    ].each do |fn|
      ln_s share+name+fn, bin
    end
  end
end
