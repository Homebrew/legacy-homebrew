class Xml2 < Formula
  desc "Makes XML and HTML more amenable to classic UNIX text tools"
  homepage "http://ofb.net/~egnor/xml2/"
  url "http://download.ofb.net/gale/xml2-0.5.tar.gz"
  sha256 "e3203a5d3e5d4c634374e229acdbbe03fea41e8ccdef6a594a3ea50a50d29705"

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "echo '<test/>' | \"#{bin}/xml2\""
  end
end
