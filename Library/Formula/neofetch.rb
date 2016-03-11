class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/1.4.tar.gz"
  sha256 "b0bda1ac5c3fa4357c6c2157767bcbf08d0e231e3d5e15c4408490f1c3175756"
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
