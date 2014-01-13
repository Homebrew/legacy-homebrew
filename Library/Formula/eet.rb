require 'formula'

class Eet < Formula
  homepage 'http://trac.enlightenment.org/e/wiki/Eet'
  url 'http://download.enlightenment.org/releases/eet-1.7.9.tar.gz'
  sha1 '843eb9733f6c01442b9c1379e9a48b69bfd5081f'

  head do
    url 'http://svn.enlightenment.org/svn/e/trunk/eet/'

    depends_on :autoconf
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
