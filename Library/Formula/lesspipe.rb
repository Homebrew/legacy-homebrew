require 'formula'

class Lesspipe < Formula
  homepage 'http://www-zeuthen.desy.de/~friebel/unix/lesspipe.html'
  url 'http://sourceforge.net/projects/lesspipe/files/lesspipe/1.81/lesspipe-1.81.tar.gz'
  sha1 '0d6e0ed6465a9186f2d3e912aacafbb5569f8d44'

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
