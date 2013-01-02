require 'formula'

class Mosml < Formula
  version '2.01'
  url 'http://www.itu.dk/people/sestoft/mosml/mos201src.tar.gz'
  homepage 'http://www.itu.dk/people/sestoft/mosml.html'
  sha1 'eba58486b10f0359fafba488fa1bf366b2aabf8a'

  def install
    cd "src"

    inreplace "Makefile.inc" do |s|
      s.change_make_var! 'MOSMLHOME', prefix
      s.change_make_var! 'DOCDIR', doc
      s.change_make_var! 'LIBDIR', lib+'mosml'
      s.change_make_var! 'TOOLDIR', lib+'mosml'
    end

    system "make", "CPP=cpp"
    system "make install"
  end
end
