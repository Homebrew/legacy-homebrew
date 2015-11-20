class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "http://www.audiocoding.com/faad2.html"
  url "https://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.7/faad2-2.7.tar.bz2"
  sha256 "14561b5d6bc457e825bfd3921ae50a6648f377a9396eaf16d4b057b39a3f63b5"

  bottle do
    cellar :any
    revision 1
    sha256 "ded931642921a5e0d236237ce046f883aa96a0e5bfe67f5d437ee31f10b5f3d1" => :el_capitan
    sha256 "c9d4798cb9ed59d6f4b9e5fa24d65e4b9afca6a390b4e0d4168975a0da43b991" => :yosemite
    sha256 "4d5c07adef1f8fbeea4e71ad42205145b38dd3e3616485b9ee44f839c6d4f1a4" => :mavericks
    sha256 "cc0b789cd93b14247f679211b2f4a592e88395304cb6cc1df91514ed9d6a9720" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    man1.install man+"manm/faad.man" => "faad.1"
  end
end
