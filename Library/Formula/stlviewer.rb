class Stlviewer < Formula
  desc "View stl files"
  homepage "https://github.com/vishpat/stlviewer#readme"
  url "https://github.com/vishpat/stlviewer/archive/release-0.1.tar.gz"
  sha256 "55c1969537a7c663273d0d3ab242f0bf61b93d83a7a5ea0786436a2041ecdb8b"

  def install
    system "./compile.py"
    bin.install "stlviewer"
  end

  test do
    shell_output("#{bin}/stlviewer 2>&1", 1)
  end
end
