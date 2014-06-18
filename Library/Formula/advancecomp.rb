require "formula"

class Advancecomp < Formula
  homepage "http://advancemame.sourceforge.net/comp-readme.html"
  url "https://downloads.sourceforge.net/project/advancemame/advancecomp/1.19/advancecomp-1.19.tar.gz"
  sha256 "d594c50c3da356aa961f75b00e958a4ed1e142c6530b42926092e46419af3047"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end

  test do
    system bin/"advdef", "--version"
    system bin/"advpng", "--version"
  end
end
