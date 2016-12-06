class YoutubeDlParallel < Formula
  desc "Spawn a number of youtube-dl processes in parallel"
  homepage "https://github.com/dlh/youtube-dl-parallel"
  url "https://github.com/dlh/youtube-dl-parallel/archive/1.0.0.tar.gz"
  sha256 "1f12c597987c37bf776a2fa1ca4b2b3913e516360b0102bc0c6e3af25ae40dbd"

  depends_on "youtube-dl"
  depends_on "parallel"

  def install
    bin.install "youtube-dl-parallel"
    doc.install "LICENSE.txt", "README.md"
  end
end
