require 'formula'

class RestShell < Formula
  homepage 'https://github.com/SpringSource/rest-shell'
  url 'https://github.com/downloads/SpringSource/rest-shell/rest-shell-1.2.1.RELEASE.tar.gz'
  version '1.2.1.RELEASE'
  sha1 'f1e31f4d3901b001cd958f339240ef04d0b97114'

  def install
    libexec.install Dir['*']
    bin.write_exec_script libexec/'bin/rest-shell'
  end

  def test
    system "#{bin}/rest-shell"
  end
end
