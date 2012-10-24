require 'formula'

class RestShell < Formula
  homepage 'https://github.com/jbrisbin/rest-shell'
  url 'https://github.com/downloads/jbrisbin/rest-shell/rest-shell-1.1.3.RELEASE.tar.gz'
  version '1.1.3.RELEASE'
  sha1 '0d43e99fabae72b068a09955053793ae4164c099'

  def startup_script name
    <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/bin/#{name}" "$@"
    EOS
  end

  def install
    libexec.install Dir['*']

    (bin+'rest-shell').write startup_script('rest-shell')
  end

  def test
    system "rest-shell"
  end
end
