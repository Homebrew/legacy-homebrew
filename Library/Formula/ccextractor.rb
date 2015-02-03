class Ccextractor < Formula
  homepage "http://ccextractor.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ccextractor/ccextractor/0.75/ccextractor.src.0.75.zip"
  sha1 "c36f8eadb2074d88782d6628e07c762e80e4c31c"
  head "https://github.com/ccextractor/ccextractor.git"

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
