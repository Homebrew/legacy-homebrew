class Wgetpaste < Formula
  desc "Automate pasting to a number of pastebin services"
  homepage "http://wgetpaste.zlin.dk/"
  url "http://wgetpaste.zlin.dk/wgetpaste-2.25.tar.bz2"
  sha256 "6a7e078e6607f4fe819fc52857a601630ec0f7d2ee855d3b1cd7e75a904c40f4"

  def install
    bin.install "wgetpaste"
  end

  test do
    system bin/"wgetpaste", "-S"
  end
end
