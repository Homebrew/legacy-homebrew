class Apparix < Formula
  desc "File system navigation via bookmarking directories"
  homepage "http://micans.org/apparix/"
  url "http://micans.org/apparix/src/apparix-11-062.tar.gz"
  sha256 "211bb5f67b32ba7c3e044a13e4e79eb998ca017538e9f4b06bc92d5953615235"

  bottle do
    cellar :any
    sha256 "b0750263f230328b5012bcc470c16ea4f4825642c8c73dca4e1da4b1b2c7f94d" => :yosemite
    sha256 "ebe99c489265dc7076b179c54d294f0289c8b1c5192bfdb0e59a999b8990491e" => :mavericks
    sha256 "b2ff9be040fe3c62354f583f3aa9fa5def715f0a01a4214d575bbc5f7d589f87" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "test"
    system "#{bin}/apparix", "--add-mark", "homebrew", "test"
    assert_equal "j,homebrew,test",
      shell_output("#{bin}/apparix -lm homebrew").chomp
  end
end
