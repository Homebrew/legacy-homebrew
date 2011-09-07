require 'formula'

class Mosml < Formula
  version '2.01'
  url 'http://www.itu.dk/people/sestoft/mosml/mos201src.tar.gz'
  homepage 'http://www.itu.dk/people/sestoft/mosml.html'
  md5 '74aaaf988201fe92a9dbfbcb1e646f70'

  def install
    cd "src"

    inreplace "Makefile.inc" do |s|
      s.change_make_var! 'MOSMLHOME', prefix
      s.gsub! '/lib/cpp', '/usr/bin/cpp'
      s.change_make_var! 'DOCDIR', doc
      s.change_make_var! 'LIBDIR', lib+'mosml'
      s.change_make_var! 'TOOLDIR', lib+'mosml'
    end

    system "make"
    system "make install"
  end
end
