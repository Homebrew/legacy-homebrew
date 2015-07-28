class Wgetpaste < Formula
  desc "Automate pasting to a number of pastebin services"
  homepage "http://wgetpaste.zlin.dk/"
  url "http://wgetpaste.zlin.dk/wgetpaste-2.26.tar.bz2"
  sha256 "9265cd0718c815cce19a12c4745f74b288cafce404a26d64daf85ddcbadc8f86"

  depends_on "wget"

  def install
    bin.install "wgetpaste"
  end

  test do
    system bin/"wgetpaste", "-S"
  end
end
