require 'formula'

class G95 < Formula
  homepage 'http://www.g95.org/index.shtml'
  url 'http://ftp.g95.org/v0.92/g95-x86-osx.tgz'
  version '0.92'
  sha1 '07e0c054971cd5d63d324d9e5a0fd1cda301f826'

  def install
    safe_system "ln -sf i386-apple-darwin9.7.0-g95 bin/g95"
    safe_system "mv bin lib #{prefix}"
    share.install "G95Manual.pdf"
  end
end
