class Makeicns < Formula
  desc "Create icns files from the command-line"
  homepage "https://bitbucket.org/mkae/makeicns"
  url "https://bitbucket.org/mkae/makeicns/downloads/makeicns-1.4.10a.tar.bz2"
  sha256 "10e44b8d84cb33ed8d92b9c2cfa42f46514586d2ec11ae9832683b69996ddeb8"
  head "https://bitbucket.org/mkae/makeicns", :using => :hg

  bottle do
    cellar :any
    sha256 "40c3d4befe2d4625d7013ea40f307b4f5b26e122a6dad51706a25bb22734f075" => :yosemite
    sha256 "8c54ce9e5f819dda4eb274f8bf8a22d49e1d0086e33300f236840acf1a46837f" => :mavericks
    sha256 "dfffe46a25b846de31dc220c279a628b719a3b353aa220ed31189bc8ce5da4b2" => :mountain_lion
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/e59da9d/makeicns/patch-IconFamily.m.diff"
    sha256 "f5ddbf6a688d6f153cf6fc2e15e75309adaf61677ab423cb67351e4fbb26066e"
  end

  def install
    system "make"
    bin.install "makeicns"
  end
end
