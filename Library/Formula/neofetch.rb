class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/1.5.tar.gz"
  sha256 "a29f9aa194892940a5ec34a449049fbce92bc50dc4a0f608549980318f4136d8"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2c24863d38a41cb6f5d034cf8901dfc3e4bc13bc47db80759b61f05e399377b" => :el_capitan
    sha256 "ee4dc42f9ec546f07121f4706df696c4da292fc644723745ad2e7f271a3143bb" => :yosemite
    sha256 "ca7ebd89b1a2b1fc2036088bf3bdc08205ae5152f14ba3b1a81315dd8b39efb2" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch"
  end
end
