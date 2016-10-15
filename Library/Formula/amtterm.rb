require 'formula'

class Amtterm < Formula
  homepage 'http://www.kraxel.org/blog/linux/amtterm/'
  url 'http://www.kraxel.org/releases/amtterm/amtterm-1.3.tar.gz'
  head 'git://git.kraxel.org/amtterm'
  sha1 'cfd199cc870f48a59caa89408b039239eab85322'

  def install
    system "make","prefix=#{prefix}", "install"
  end

  test do
    system "#{bin}/amtterm"
  end
end
