class Apparix < Formula
  homepage "http://micans.org/apparix/"
  url "http://micans.org/apparix/src/apparix-11-062.tar.gz"
  sha256 "211bb5f67b32ba7c3e044a13e4e79eb998ca017538e9f4b06bc92d5953615235"

  bottle do
    cellar :any
    sha256 "95d294acae9177133291fd95375d16f37a2ff606a628116a51c0b1aea3d7494c" => :yosemite
    sha256 "9c460d709002ff092701d2cbd3cf301231eeaa4e5de6fceb59d088c5b0fde7f7" => :mavericks
    sha256 "6e839a989c4495bb498d2d682cd98434d50eb659582ba4d5d07b4438bd4922e4" => :mountain_lion
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
