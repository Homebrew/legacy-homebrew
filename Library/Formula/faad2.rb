class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "http://www.audiocoding.com/faad2.html"
  url "https://downloads.sourceforge.net/project/faac/faad2-src/faad2-2.7/faad2-2.7.tar.bz2"
  sha256 "14561b5d6bc457e825bfd3921ae50a6648f377a9396eaf16d4b057b39a3f63b5"

  bottle do
    cellar :any
    revision 1
    sha256 "ded931642921a5e0d236237ce046f883aa96a0e5bfe67f5d437ee31f10b5f3d1" => :el_capitan
    sha1 "39cc3707e90db859db8cb135ccd7080f9c304459" => :yosemite
    sha1 "04c2c277cfd485ccf2741e0655d80f5e15cf8cd3" => :mavericks
    sha1 "08c8bc69ca372e20e233da8deabd5367ea0f345d" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    man1.install man+"manm/faad.man" => "faad.1"
  end
end
