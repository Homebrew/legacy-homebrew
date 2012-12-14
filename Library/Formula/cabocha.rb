require 'formula'

class Cabocha < Formula
  homepage 'http://code.google.com/p/cabocha/'
  url 'http://cabocha.googlecode.com/files/cabocha-0.65.tar.bz2'
  sha1 'f8e38f2ef3feda398e14824a736e4cceebd2a658'

  depends_on 'crf++'
  depends_on 'mecab'

  def install
    ENV["LIBS"] = '-liconv'

    inreplace 'Makefile.in' do |s|
      s.change_make_var! 'CFLAGS', ENV.cflags
      s.change_make_var! 'CXXFLAGS', ENV.cflags
    end

    system "./configure", "--with-charset=utf8",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
