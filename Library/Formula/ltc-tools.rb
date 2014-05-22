require "formula"

class LtcTools < Formula
  homepage "https://github.com/x42/ltc-tools"
  url "https://github.com/x42/ltc-tools/archive/v0.6.4.tar.gz"
  sha1 "b126223996b06ac3dd900b322e3ccda9267bcbb3"
  head "https://github.com/x42/ltc-tools.git"

  depends_on "pkg-config" => :build
  depends_on "help2man" => :build
  depends_on "libltc"
  depends_on "libsndfile"
  depends_on "jack"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"ltcgen", "test.wav"
    system bin/"ltcdump", "test.wav"
  end
end
