require 'formula'

class Authexec < Formula
  url 'http://vafer.org/pub/cocoa/authexec.zip'
  homepage 'http://vafer.org/blog/20060211170210'
  md5 '0644931a28960a59b7720eb37d035c2e'
  version '2010-01-28'

  def install
    inreplace "Makefile", "gcc", "$(CC)"
    system 'make all'
    bin.install 'authexec'
  end
end
