class Csvprintf < Formula
  desc "Command-line utility for parsing CSV files"
  homepage "https://github.com/archiecobbs/csvprintf"
  url "https://github.com/archiecobbs/csvprintf/archive/1.0.3.tar.gz"
  sha256 "484db6a5f0cdb1a09b375274b30fbbde3c886d5da974d3f247c83b0bf853ef83"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    ENV.append "LDFLAGS", "-liconv"
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "Fred Smith\n",
                 pipe_output("#{bin}/csvprintf -i '%2$s %1$s\n'", "Last,First\nSmith,Fred\n")
  end
end
