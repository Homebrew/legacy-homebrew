class Rgxg < Formula
  desc "C library and command-line tool to generate (extended) regular expressions"
  homepage "http://rgxg.sourceforge.net"
  url "https://downloads.sourceforge.net/project/rgxg/rgxg/rgxg-0.1.tar.gz"
  sha256 "4adbc128faf87e44ec80d9dfd3b34871c84634c2ae0f9cfaedd16b07d13f9484"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rgxg", "range", "1", "10"
  end
end
