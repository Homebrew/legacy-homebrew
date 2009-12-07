require 'formula'

class Libxml2 <Formula
  url 'ftp://xmlsoft.org/libxml2/libxml2-2.7.6.tar.gz'
  homepage 'http://xmlsoft.org'
  md5 '7740a8ec23878a2f50120e1faa2730f2'

  def keg_only?
    :provided_by_osx
  end

  def install
    ENV.gcc_4_2
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    ENV.j1
    system "make install"
  end
end
