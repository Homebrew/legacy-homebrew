require 'formula'

class Uni2ascii < Formula
  url 'http://billposer.org/Software/Downloads/uni2ascii-4.18.tar.gz'
  homepage 'http://billposer.org/Software/uni2ascii.html'
  md5 '096cf1b70a55c4796b136ff1a126a940'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "MKDIRPROG='mkdir -p' make install"
  end

  def test
    system "uni2ascii"
  end
end
