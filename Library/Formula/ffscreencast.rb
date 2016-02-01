class Ffscreencast < Formula
  desc "ffmpeg screencast with video overlay & multi monitor support"
  homepage "https://github.com/cytopia/ffscreencast"
  url "https://github.com/cytopia/ffscreencast/archive/v0.6.tar.gz"
  sha256 "1d55d652347b26cb3b1a15398704cb4d82a3a996dcd967643ffa44347b431e81"

  depends_on "ffmpeg" => [
    "with-x265",
    "with-faac",
  ]

  def install
    bin.install "ffscreencast"
  end

  test do
    system bin/"ffscreencast --test"
  end
end
