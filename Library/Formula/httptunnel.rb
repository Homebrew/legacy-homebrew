class Httptunnel < Formula
  desc "Tunnels a data stream in HTTP requests"
  homepage "http://www.nocrew.org/software/httptunnel.html"
  url "http://www.nocrew.org/software/httptunnel/httptunnel-3.3.tar.gz"
  sha256 "142f82b204876c2aa90f19193c7ff78d90bb4c2cba99dfd4ef625864aed1c556"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
