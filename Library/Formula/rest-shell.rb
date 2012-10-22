require 'formula'

class RestShell < Formula
  homepage 'https://github.com/jbrisbin/rest-shell'
  url 'https://github.com/downloads/jbrisbin/rest-shell/rest-shell-1.1.2.RELEASE.tar.gz'
  version '1.1.2.RELEASE'
  sha1 '55fa274283e8e32d12c7ba03406a59eda3ccab34'

  def install
    libexec.install Dir['*']
    (bin/'rest-shell').write <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/bin/rest-shell" "$@"
    EOS
  end

  def test
    system "#{bin}/rest-shell"
  end
end
