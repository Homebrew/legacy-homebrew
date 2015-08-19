class LtcTools < Formula
  desc "Tools to deal with linear-timecode (LTC)"
  homepage "https://github.com/x42/ltc-tools"
  url "https://github.com/x42/ltc-tools/archive/v0.6.4.tar.gz"
  sha256 "8fc9621df6f43ab24c65752a9fee67bee6625027c19c088e5498d2ea038a22ec"
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
