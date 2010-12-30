require 'formula'

class Cromfs <Formula
  url 'http://bisqwit.iki.fi/src/arch/cromfs-1.5.9.tar.bz2'
  homepage 'http://bisqwit.iki.fi/source/cromfs.html'
  md5 ''

  def install
    ENV.append "CXXFLAGS", "-fpermissive"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
	system "make"
    system "make install"
  end
end
