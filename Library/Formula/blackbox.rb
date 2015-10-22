class Blackbox < Formula
  homepage "http://the-cloud-book.com/"
  url "https://github.com/StackExchange/blackbox/archive/v1.20150730.tar.gz"
  version "1.20150730"
  sha256 "a28237e8839d000273d0fe0ba8f9701cab66a3b942787c5c8e8d329912564ae4"

  depends_on "git"
  depends_on "gpg" 

  def install
    bin.install Dir["bin/*"]
  end

  test do
    system "#{bin}/git", "init"
    system "#{bin}/blackbox_initialize", "yes"
  end
end

