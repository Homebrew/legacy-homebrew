class Ioping < Formula
  homepage "https://github.com/koct9i/ioping"
  url "https://github.com/koct9i/ioping/releases/download/v0.9/ioping-0.9.tar.gz"
  sha256 "951e430875987c8cfe0ed85a0bcfe1081788121a34102eb6f7c91330c63a775d"

  head "https://github.com/koct9i/ioping.git"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ioping", "-v"
  end
end
