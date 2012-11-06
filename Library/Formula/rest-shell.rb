require 'formula'

class RestShell < Formula
  homepage 'https://github.com/SpringSource/rest-shell'
  url 'https://github.com/downloads/SpringSource/rest-shell/rest-shell-1.1.4.RELEASE.tar.gz'
  version '1.1.4.RELEASE'
  sha1 'e34def6696c9c5834eaf5781c1eb8e6ab34ff86f'

  def install
    libexec.install Dir['*']
    bin.write_exec_script libexec/'bin/rest-shell'
  end

  def test
    system "#{bin}/rest-shell"
  end
end
