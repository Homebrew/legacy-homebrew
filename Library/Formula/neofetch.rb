class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/1.4.tar.gz"
  sha256 "b0bda1ac5c3fa4357c6c2157767bcbf08d0e231e3d5e15c4408490f1c3175756"
  head "https://github.com/dylanaraps/neofetch.git"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch"
  end
end
