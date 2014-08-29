require "formula"

class Colormake < Formula
  homepage "https://github.com/pagekite/Colormake"
  head "https://github.com/pagekite/Colormake.git"
  url "https://github.com/pagekite/Colormake/archive/0.9.20140503.tar.gz"
  sha1 "2804a550bfee7304015569552ff77a2d9c3eddf8"

  def install
    inreplace "colormake", "colormake.pl", "#{libexec}/colormake.pl"

    # Prefers symlinks than the original duplicate files
    File.unlink "colormake-short", "clmake", "clmake-short"
    File.symlink "colormake", "colormake-short"
    File.symlink "colormake", "clmake"
    File.symlink "colormake", "clmake-short"

    # Adds missing clmake.1 referenced in colormake.1 itself
    File.symlink "colormake.1", "clmake.1"

    # Installs auxiliary script, commands and mans
    libexec.install "colormake.pl"
    bin.install "colormake", "clmake", "colormake-short", "clmake-short"
    man1.install "colormake.1", "clmake.1"
  end
end
