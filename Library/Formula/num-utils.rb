class NumUtils < Formula
  desc "Programs for dealing with numbers from the command-line"
  homepage "http://suso.suso.org/programs/num-utils/"
  url "http://suso.suso.org/programs/num-utils/downloads/num-utils-0.5.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/num-utils/num-utils_0.5.orig.tar.gz"
  sha256 "03592760fc7844492163b14ddc9bb4e4d6526e17b468b5317b4a702ea7f6c64e"

  bottle do
    cellar :any
    sha256 "41a55ac6c46aca45473ca365443fb1fd2d77fdb6e4540edbe849d723d31ba0e0" => :yosemite
    sha256 "188ff1f94691f8bf5099ec1012d4732be8fa385bf738671f86780376dd2597b9" => :mavericks
    sha256 "ef3654fed50aff148b0264fdfc75f25310702e8931cc6dcecb4bb3ebce657f7a" => :mountain_lion
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
