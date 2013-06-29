require 'formula'

class Jerm < Formula
  homepage 'http://www.bsddiary.net/jerm/'
  url 'http://www.bsddiary.net/jerm/jerm-8096.tar.gz'
  version '0.8096'
  sha1 '09a301d9de423c44e60967f3f617a299427e356d'

  def install
    system "make all"
    bin.install %w{jerm tiocdtr}
    man1.install Dir["*.1"]
  end
end
