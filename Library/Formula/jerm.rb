require 'formula'

class Jerm < Formula
  url 'http://www.bsddiary.net/jerm/jerm-8096.tar.gz'
  version '0.8096'
  homepage 'http://www.bsddiary.net/jerm/'
  md5 'c178699945e60b32cfc8394c6aa5901c'

  def install
    system "make all"
    system "mkdir -p #{bin}"
    system "cp jerm tiocdtr #{bin}"
    system "mkdir -p #{man1}"
    system "cp *.1 #{man1}"
  end
end
