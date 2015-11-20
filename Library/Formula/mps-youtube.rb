class MpsYoutube < Formula
  desc "Terminal-based YouTube player and downloader."
  homepage "https://github.com/np1/mps-youtube"
  url "https://github.com/mps-youtube/mps-youtube/archive/v0.2.5.tar.gz"
  sha256 "74d196058c9369a3587f076cafb1ee15baeb6be1465e270f7de9d9830463c869"
  depends_on "mpv" => :recommended
  depends_on "pafy" => :python

  def install
  end

  test do
  end
end
