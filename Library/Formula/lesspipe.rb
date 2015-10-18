class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://downloads.sourceforge.net/project/lesspipe/lesspipe/1.82/lesspipe-1.82.tar.gz"
  sha256 "3fd345b15d46cc8fb0fb1d625bf8d881b0637abc34d15df45243fd4e5a8f4241"

  bottle do
    cellar :any
    sha256 "3a8e56f9b9b38d291d57f3a702e0dfb488814fb4686594084aa10a97f0cf2448" => :yosemite
    sha256 "f33d17225509888d6193b1c5bac74577168d57cccd274065d195c9661774c68a" => :mavericks
    sha256 "201d33d2ae2aff83e00bbcea23bf872f2a20938ba194d175426837fc041117c0" => :mountain_lion
  end

  option "with-syntax-highlighting", "Build with syntax highlighting"

  deprecated_option "syntax-highlighting" => "with-syntax-highlighting"

  def install
    if build.with? "syntax-highlighting"
      inreplace "configure", %q($ifsyntax = "\L$ifsyntax";), %q($ifsyntax = "\Ly";)
    end

    system "./configure", "--prefix=#{prefix}", "--yes"
    man1.mkpath
    system "make", "install"
  end

  test do
    touch "file1.txt"
    touch "file2.txt"
    system "tar", "-cvzf", "homebrew.tar.gz", "file1.txt", "file2.txt"

    assert File.exist?("homebrew.tar.gz")
    assert_match /file2.txt/, shell_output("tar tvzf homebrew.tar.gz | #{bin}/tarcolor")
  end
end
