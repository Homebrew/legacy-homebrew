require 'formula'

class Libflowmanager < Formula
  homepage 'http://research.wand.net.nz/software/libflowmanager.php'
  url 'http://research.wand.net.nz/software/libflowmanager/libflowmanager-2.0.2.tar.gz'
  sha1 '77efc29fc9442bd330c00615f1f2657b30456d4f'

  depends_on 'libtrace'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
