require 'formula'

class RestShell < Formula
  homepage 'https://github.com/SpringSource/rest-shell'
  url 'https://github.com/downloads/SpringSource/rest-shell/rest-shell-1.2.0.RELEASE.tar.gz'
  version '1.2.0.RELEASE'
  sha1 '747f43454e91a5c25d1342f499b57326b0d17d9a'

  def install
    libexec.install Dir['*']
    bin.write_exec_script libexec/'bin/rest-shell'
  end

  def test
    system "#{bin}/rest-shell"
  end
end
