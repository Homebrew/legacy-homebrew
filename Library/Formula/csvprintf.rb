class Csvprintf < Formula
  desc "Command-line utility for parsing CSV files"
  homepage "https://code.google.com/p/csvprintf/"
  url "https://csvprintf.googlecode.com/files/csvprintf-1.0.3.tar.gz"
  sha256 "6bc848141447e11af61d0e3fc900b35f13d9d779ddcdfd77d1070d523c708014"

  def install
    ENV.append "LDFLAGS", "-liconv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "Fred Smith\n",
                 pipe_output("#{bin}/csvprintf -i '%2$s %1$s\n'", "Last,First\nSmith,Fred\n")
  end
end
