require 'formula'

class Xdelta < Formula
  homepage 'http://xdelta.org'
  url 'http://xdelta.googlecode.com/files/xdelta3-3.0.1.tar.gz'
  sha1 '7eae42bd16f4c9c33be85c2faf420c36541bfa61'

  # Fixed upstream in SVN revision 350
  # Can be removed in 3.0.2
  fails_with :clang do
    build 318
    cause "Undefined symbols for architecture x86_64: \"_xd3_source_eof\""
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
