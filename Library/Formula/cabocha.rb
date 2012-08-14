require 'formula'

class Cabocha < Formula
  homepage 'http://code.google.com/p/cabocha/'
  url 'http://cabocha.googlecode.com/files/cabocha-0.64.tar.gz'
  sha1 '13f18c4aae2d75f5c7ac69c87458912fc00b4174'

  depends_on 'crf++'

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
