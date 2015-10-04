class Darkhttpd < Formula
  desc "Small static webserver without CGI"
  homepage "http://unix4lyfe.org/darkhttpd/"
  url "http://unix4lyfe.org/darkhttpd/darkhttpd-1.10.tar.bz2"
  sha256 "b5a9bcfe6e65a3fc20f96e6badb5da7ba776a792f13fe90015fe9f63b3c2eb63"

  def install
    system "make"
    bin.install "darkhttpd"
  end

  test do
    system "#{bin}/darkhttpd", "--help"
  end
end
