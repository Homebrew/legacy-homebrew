require 'formula'

class Aria2 < Formula
  homepage 'http://aria2.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.14.2/aria2-1.14.2.tar.bz2'
  md5 '19b1a9f83a09c6ef5c7ab87e4e0f7974'

  depends_on 'pkg-config' => :build

  # Leopard's libxml2 is too old.
  depends_on 'libxml2' if MacOS.leopard?

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      call to function 'stripIter' that is neither visible in the
      template definition nor found by argument-dependent lookup
      EOS
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
