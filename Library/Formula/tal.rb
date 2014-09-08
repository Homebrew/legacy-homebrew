require 'formula'

class Tal < Formula
  homepage 'http://thomasjensen.com/software/tal/'
  url 'http://thomasjensen.com/software/tal/tal-1.9.tar.gz'
  sha1 'c889477eee1ca362c071667563882c6aed38c0cb'

  def install
    system "make linux"
    bin.install 'tal'
    man1.install 'tal.1'
  end

  test do
    system "#{bin}/tal", "/etc/passwd"
  end
end
