class NumUtils < Formula
  desc "Programs for dealing with numbers from the command-line"
  homepage "http://suso.suso.org/programs/num-utils/"
  url "http://suso.suso.org/programs/num-utils/downloads/num-utils-0.5.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/num-utils/num-utils_0.5.orig.tar.gz"
  sha256 "03592760fc7844492163b14ddc9bb4e4d6526e17b468b5317b4a702ea7f6c64e"

  bottle do
    cellar :any
    sha1 "47f40b81881dc56d9966b7567accb17d597a4d5e" => :yosemite
    sha1 "97e1e6391d8c31ab79085466c86227ebb60ca779" => :mavericks
    sha1 "4a610ddbfa56751bc9aeb8954a60f56648d5b2d8" => :mountain_lion
  end

  conflicts_with "normalize", :because => "both install `normalize` binaries"
  conflicts_with "crush-tools", :because => "both install an `range` binary"
  conflicts_with "argyll-cms", :because => "both install `average` binaries"

  def install
    %w[average bound interval normalize numgrep numprocess numsum random range round].each do |p|
      system "pod2man", p, "#{p}.1"
      bin.install p
      man1.install "#{p}.1"
    end
  end

  test do
    assert_equal "2", pipe_output("#{bin}/average", "1\n2\n3\n").strip
  end
end
