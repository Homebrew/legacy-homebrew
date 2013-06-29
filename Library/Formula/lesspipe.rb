require 'formula'

class Lesspipe < Formula
  homepage 'http://www-zeuthen.desy.de/~friebel/unix/lesspipe.html'
  url 'http://sourceforge.net/projects/lesspipe/files/lesspipe/1.82/lesspipe-1.82.tar.gz'
  sha1 '61a7657b20b910ed8219c6b77467e601f9a89894'

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
