require 'formula'

class Mmsrip < Formula
  homepage 'http://nbenoit.tuxfamily.org/index.php?page=MMSRIP'
  url 'http://nbenoit.tuxfamily.org/projects/mmsrip/mmsrip-0.7.0.tar.gz'
  sha1 '2a51b85b0733001b312bae186e8360138748b1f3'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/mmsrip", "-v"
  end
end
