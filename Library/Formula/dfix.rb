class Dfix < Formula
  desc "Auto-upgrade tool for D source code"
  homepage "https://github.com/Hackerpilot/dfix"
  url "https://github.com/Hackerpilot/dfix.git",
      :tag => "v0.3.1",
      :revision => "d796fb0d04882dc31862a808e2cff03ff829b56a"
  head "https://github.com/Hackerpilot/dfix.git", :shallow => false

  bottle do
    sha256 "6b19da6a3db617b0dcce69a9c19b6b212e6f64adaacfe0e7296328c74aa8f398" => :el_capitan
    sha256 "28db097fe0facaa42f4b1a441f89237e1ad2480ecb7d81f56dd6937d586e1974" => :yosemite
    sha256 "186aaedeb0b223858a5cb16e133ef03886fe81ece596e376c111342251842c5e" => :mavericks
  end

  depends_on "dmd" => :build

  def install
    system "make"
    system "make", "test"
    bin.install "bin/dfix"
    pkgshare.install "test/testfile_expected.d", "test/testfile_master.d"
  end

  test do
    system "#{bin}/dfix", "--help"

    cp "#{pkgshare}/testfile_master.d", "testfile.d"
    system "#{bin}/dfix", "testfile.d"
    system "diff", "testfile.d", "#{pkgshare}/testfile_expected.d"
    # Make sure that running dfix on the output of dfix changes nothing.
    system "#{bin}/dfix", "testfile.d"
    system "diff", "testfile.d", "#{pkgshare}/testfile_expected.d"
  end
end
