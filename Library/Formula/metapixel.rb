require 'formula'

class Metapixel <Formula
  url 'http://www.complang.tuwien.ac.at/schani/metapixel/files/metapixel-1.0.2.tar.gz'
  homepage 'http://www.complang.tuwien.ac.at/schani/metapixel/'
  md5 'af5d77d38826756af213a08e3ada9941'

  depends_on 'jpeg'
  depends_on 'giflib'

  def install
    inreplace "Makefile" do |s|
      s.remove_make_var! "CC"
      s.change_make_var! "PREFIX", prefix
      s.change_make_var! "MACOS_LDOPTS", "-L#{HOMEBREW_PREFIX}/lib"
      s.change_make_var! "MACOS_CCOPTS", "-I#{HOMEBREW_PREFIX}/include"
    end
    man1.mkpath
    system "make"
    system "make install"
  end
end
