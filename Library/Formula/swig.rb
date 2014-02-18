require 'formula'

class Swig < Formula
  homepage 'http://www.swig.org/'
  url 'http://downloads.sourceforge.net/project/swig/swig/swig-2.0.12/swig-2.0.12.tar.gz'
  sha1 '4203c68f79012a2951f542018ff4358d838b5035'

  option :universal

  depends_on 'pcre'

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
