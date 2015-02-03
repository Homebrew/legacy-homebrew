class Ccextractor < Formula
  homepage "http://ccextractor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.75/ccextractor.src.0.75.zip"
  sha1 "c36f8eadb2074d88782d6628e07c762e80e4c31c"
  head "https://github.com/ccextractor/ccextractor.git"

  bottle do
    cellar :any
    sha1 "12fc81b745160eaf4d664907defe87230ffa022e" => :yosemite
    sha1 "4e4775826383cc891cb63f9f33f5d5a0f74ff5ac" => :mavericks
    sha1 "9eefc9ce1714e675a9ef01841e79b6b72170173d" => :mountain_lion
  end

  def install
    cd "mac" do
      system "bash", "./build.command"
      bin.install "ccextractor"
    end
    (share+"examples").install "docs/ccextractor.cnf.sample"
  end

  test do
    # Without a closed captioned file to play with, we're limited here.
    assert_match /outputfilename/, pipe_output("#{bin}/ccextractor 2>&1")
  end
end
