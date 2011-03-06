require 'formula'

class Libtommath < Formula
  url 'http://libtom.org/files/ltm-0.42.0.tar.bz2'
  homepage 'http://libtom.org/?page=features&newsitems=5&whatfile=ltm'
  md5 '7380da904b020301be7045cb3a89039b'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "DESTDIR", prefix
      s.change_make_var! "LIBPATH", "/lib"
      s.change_make_var! "INCPATH", "/include"

      s.gsub! "-g $(GROUP) -o $(USER)", ""
    end

    system "make"
    system "make install"
  end
end
