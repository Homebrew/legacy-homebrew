require 'formula'

class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage 'http://www-zeuthen.desy.de/~friebel/unix/lesspipe.html'
  url 'https://downloads.sourceforge.net/project/lesspipe/lesspipe/1.82/lesspipe-1.82.tar.gz'
  sha1 '61a7657b20b910ed8219c6b77467e601f9a89894'

  bottle do
    cellar :any
    sha256 "3a8e56f9b9b38d291d57f3a702e0dfb488814fb4686594084aa10a97f0cf2448" => :yosemite
    sha256 "f33d17225509888d6193b1c5bac74577168d57cccd274065d195c9661774c68a" => :mavericks
    sha256 "201d33d2ae2aff83e00bbcea23bf872f2a20938ba194d175426837fc041117c0" => :mountain_lion
  end

  option 'syntax-highlighting', 'Enable syntax highlighting'

  def install
    if build.include? 'syntax-highlighting'
      inreplace 'configure', %q{$ifsyntax = "\L$ifsyntax";}, %q{$ifsyntax = "\Ly";}
    end

    system "./configure", "--prefix=#{prefix}", "--yes"
    man1.mkpath
    system "make install"
  end
end
