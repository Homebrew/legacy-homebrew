class Faust < Formula
  desc "Domain-specific language for audio signal processing algorithms"
  homepage "http://faust.grame.fr/"
  url "https://downloads.sourceforge.net/project/faudiostream/faust-0.9.73.tgz"
  sha256 "6512828b00e7a5a6d5ed6efc44dc54381991275abdc8aacf3a5deecd67675a74"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/faust", "--version"
  end
end
