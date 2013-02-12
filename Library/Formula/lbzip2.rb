require 'formula'

class Lbzip2 < Formula
  homepage 'https://github.com/kjn/lbzip2'
  url 'https://github.com/downloads/kjn/lbzip2/lbzip2-2.2.tar.gz'
  sha1 '7c1fedbfec6aa3b10a4d3411078216f3fde252c3'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"
  end

  test do
    system 'touch', 'fish'
    system 'lbzip2', 'fish'
    system 'lbunzip2', 'fish.bz2'
  end
end
