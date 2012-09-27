require 'formula'

class Lesspipe < Formula
  homepage 'http://www-zeuthen.desy.de/~friebel/unix/lesspipe.html'
  url 'http://www-zeuthen.desy.de/~friebel/unix/less/lesspipe-1.72.tar.gz'
  sha1 '971636765c32573eba6b9f63cda33e70301a7274'

  option 'syntax-highlighting', 'Enable syntax highlighting'

  def install
    if build.include? 'syntax-highlighting'
      inreplace 'configure', %q{$ifsyntax = "\L$ifsyntax";}, %q{$ifsyntax = "\Ly";}
    end

    system "./configure", "--prefix=#{prefix}", "--default"
    man1.mkpath
    system "make install"
  end
end
