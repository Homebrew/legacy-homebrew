require "formula"

class Udptunnel < Formula
  homepage "http://www.cs.columbia.edu/~lennox/udptunnel"
  url "http://www.cs.columbia.edu/~lennox/udptunnel/udptunnel-1.1.tar.gz"
  sha1 "c768097d9bca23d6be35931b010b75a451f34eb8"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install "udptunnel.html"
  end

  test do
    system "#{bin}/udptunnel -h; true"
  end
end
