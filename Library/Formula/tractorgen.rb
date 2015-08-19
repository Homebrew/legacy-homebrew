class Tractorgen < Formula
  desc "Generates ASCII tractor art"
  homepage "http://www.kfish.org/software/tractorgen/"
  url "http://www.kfish.org/software/tractorgen/dl/tractorgen-0.31.7.tar.gz"
  sha256 "469917e1462c8c3585a328d035ac9f00515725301a682ada1edb3d72a5995a8f"

  bottle do
    cellar :any
    sha256 "e50de2fd2d9015873282a62fc7a21f3ef419d527d07eeab3830ace52ec25c3c9" => :yosemite
    sha256 "acbfbe90462924fbc6f2658ca0ee591a122639356ce6ff042b558199b477bf4a" => :mavericks
    sha256 "bcc0f270ae8414659db18f339044a3030beff37c8a4a305c1c544919b2fb0a7e" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
