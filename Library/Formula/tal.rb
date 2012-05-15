require 'formula'

class Tal < Formula
  homepage 'http://thomasjensen.com/software/tal/'
  url 'http://thomasjensen.com/software/tal/tal-1.9.tar.gz'
  md5 'a22e53f5f0d701a408e98e480311700b'

  def install
    system "make linux"
    bin.install 'tal'
    man1.install 'tal.1'
  end

  def test
    system "#{bin}/tal", "/etc/passwd"
  end
end
