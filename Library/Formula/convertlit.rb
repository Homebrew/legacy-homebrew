require 'formula'

class Convertlit < Formula
  version '1.8'
  url 'http://www.convertlit.com/clit18src.zip'
  homepage 'http://www.convertlit.com/'
  md5 'd691d4729485fe5d73e3f0937d8fb42e'

  depends_on 'libtommath'

  def install

    inreplace "clit18/Makefile", "-I ../libtommath-0.30", "#{Formula.factory('libtommath').prefix}/include"
    inreplace "clit18/Makefile", "../libtommath-0.30/libtommath.a", "#{Formula.factory('libtommath').prefix}/lib/libtommath.a"

    Dir.chdir "lib"
    system "make"
    Dir.chdir "../clit18"
    system "make"

    bin.install 'clit'

  end

end
