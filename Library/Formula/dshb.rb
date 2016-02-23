class Dshb < Formula
  desc "OS X system monitor in Swift"
  homepage "https://github.com/beltex/dshb"
  url "https://github.com/beltex/dshb/releases/download/v0.1.0/dshb-0.1.0-source.zip"
  sha256 "efed42a2be0dbc6de3b22b314b582b1d6517922b72e08e063f3d1d3810a782f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "491d5a425463fb4f328503f91cfe6e28a0785fdbf8ec7a323a366bab54e4158c" => :el_capitan
    sha256 "94085328f6ef593ca0d00923fabfe43586c1c4b51eaf555ce9c7db9d7db1f486" => :yosemite
  end

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
