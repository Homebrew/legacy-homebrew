require 'formula'

class Jerm < Formula
  url 'http://www.bsddiary.net/jerm/jerm-8096.tar.gz'
  version '0.8096'
  homepage 'http://www.bsddiary.net/jerm/'
  md5 'c178699945e60b32cfc8394c6aa5901c'

  def install
    system "make all"
    bin.install %w{jerm tiocdtr}
    man1.install Dir["*.1"]
  end
end
