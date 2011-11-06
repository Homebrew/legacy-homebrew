require 'formula'

class Lesspipe < Formula
  homepage 'http://www-zeuthen.desy.de/~friebel/unix/lesspipe.html'
  url 'http://www-zeuthen.desy.de/~friebel/unix/less/lesspipe-1.71.tar.gz'
  md5 '6d921dc4ce9809d405cb8d694ac7cbbd'

  def options
    [['--syntax-highlighting', 'Enable syntax highlighting']]
  end

  def install
    if ARGV.include? '--syntax-highlighting'
      inreplace 'configure', %q{$ifsyntax = "\L$ifsyntax";}, %q{$ifsyntax = "\Ly";}
    end

    system "./configure", "--prefix=#{prefix}", "--default"
    man1.mkpath
    system "make install"
  end
end
