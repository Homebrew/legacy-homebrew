class Dshb < Formula
  desc "OS X system monitor in Swift"
  homepage "https://github.com/beltex/dshb"
  url "https://github.com/beltex/dshb/releases/download/v0.1.0/dshb-0.1.0-source.zip"
  sha256 "efed42a2be0dbc6de3b22b314b582b1d6517922b72e08e063f3d1d3810a782f9"

  depends_on :xcode => ["7.0", :build]

  def install
    system "make", "release"
    bin.install "bin/dshb"
    man1.install "doc/dshb.1"
  end

  test do
    ENV["TERM"] = "xterm"
    pipe_output("#{bin}/dshb", "q", 0)
  end
end
