require 'formula'

class Eet < Formula
  homepage 'http://trac.enlightenment.org/e/wiki/Eet'
  url 'http://download.enlightenment.org/releases/eet-1.7.5.tar.gz'
  sha1 'e418110ffdfe1a3ed32b9bc68e4f7bf628d16654'

  head 'http://svn.enlightenment.org/svn/e/trunk/eet/'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build
  depends_on 'eina'
  depends_on 'jpeg'
  depends_on 'lzlib'

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
