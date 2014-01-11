require 'formula'

class Cabocha < Formula
  homepage 'http://code.google.com/p/cabocha/'
  url 'http://cabocha.googlecode.com/files/cabocha-0.67.tar.bz2'
  sha1 '457a9bd0d264a1146a5eb1c5a504dd90a8b51fb8'

  depends_on 'crf++'
  depends_on 'mecab'

  option 'with-juman', 'use juman posset'
  option 'with-unidic', 'use unidic posset'

  def install
    ENV["LIBS"] = '-liconv'

    inreplace 'Makefile.in' do |s|
      s.change_make_var! 'CFLAGS', ENV.cflags
      s.change_make_var! 'CXXFLAGS', ENV.cflags
    end

    args = ["--with-charset=utf8",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--with-posset=JUMAN" if build.with? "juman"
    args << "--with-posset=UNIDIC" if build.with? "unidic"

    system "./configure", *args
    system "make install"
  end
end
