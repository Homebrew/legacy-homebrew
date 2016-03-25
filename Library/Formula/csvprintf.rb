class Csvprintf < Formula
  desc "Command-line utility for parsing CSV files"
  homepage "https://github.com/archiecobbs/csvprintf"
  url "https://github.com/archiecobbs/csvprintf/archive/1.0.3.tar.gz"
  sha256 "484db6a5f0cdb1a09b375274b30fbbde3c886d5da974d3f247c83b0bf853ef83"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ad1c8501cb1f51bd6910edb2a9da1c55507186020d7340e83a178a4a036df4d" => :el_capitan
    sha256 "58691d8d4819618731ebdd034ae390ae8668b7e26017ef74d5edfe2c6daa4eb1" => :yosemite
    sha256 "269a3ceaa3acb2a0f8c3df760af3647cb64215d5dee4c8907af7b20200aab418" => :mavericks
    sha256 "762b98a66e435d7a9d4661565c73df656d8f7adc8ae7defe84e0d1ed0a31d280" => :mountain_lion
  end

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
