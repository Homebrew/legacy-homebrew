class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/1.5.tar.gz"
  sha256 "a29f9aa194892940a5ec34a449049fbce92bc50dc4a0f608549980318f4136d8"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec6a9b1987d75e5d545a1cbcd1da26571baa9979cb32b55bfe98cf025b35c068" => :el_capitan
    sha256 "33f1f658b5a36e6f04577715d44847774520341e8f256882fb87631536ed4376" => :yosemite
    sha256 "173881078b2130063e03593cd437d8c8d10b511f94d84e362c51c67364cdcb5c" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch"
  end
end
