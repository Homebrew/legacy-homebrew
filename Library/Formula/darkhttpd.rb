class Darkhttpd < Formula
  desc "Small static webserver without CGI"
  homepage "https://unix4lyfe.org/darkhttpd/"
  url "https://unix4lyfe.org/darkhttpd/darkhttpd-1.12.tar.bz2"
  sha256 "a50417b622b32b5f421b3132cb94ebeff04f02c5fb87fba2e31147d23de50505"

  def install
    system "make"
    bin.install "darkhttpd"
  end

  test do
    system "#{bin}/darkhttpd", "--help"
  end
end
