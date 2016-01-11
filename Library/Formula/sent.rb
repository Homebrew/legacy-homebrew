class Sent < Formula
  desc "Simple plaintext presentation tool."
  homepage "http://tools.suckless.org/sent/"
  url "http://dl.suckless.org/tools/sent-0.2.tar.gz"
  sha256 "53b961f9d92a277a6408df7025b4a6deae6b655a797383c93442290e45391076"

  depends_on :x11 => :build

  def install
    system "make"
    bin.install "sent"
  end

end
