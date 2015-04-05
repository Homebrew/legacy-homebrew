class Rpg < Formula
  homepage "https://github.com/rtomayko/rpg"
  url "https://github.com/downloads/rtomayko/rpg/rpg-0.3.0.tar.gz"
  sha256 "c350f64744fb602956a91a57c8920e69058ea42e4e36b0e74368e96954d9d0c7"

  head "https://github.com/rtomayko/rpg.git"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/rpg", "config"
  end
end
