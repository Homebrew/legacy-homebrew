require 'formula'

class Amtterm < Formula
  head 'git://git.kraxel.org/amtterm'
  homepage 'http://www.kraxel.org/blog/linux/amtterm/'
  url 'http://www.kraxel.org/releases/amtterm/amtterm-1.3.tar.gz'
  sha1 'cfd199cc870f48a59caa89408b039239eab85322'

  def install
    system "make","prefix=#{prefix}", "install"
  end
end
