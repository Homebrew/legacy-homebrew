class Dfix < Formula
  desc "Auto-upgrade tool for D source code"
  homepage "https://github.com/Hackerpilot/dfix"
  url "https://github.com/Hackerpilot/dfix.git",
      :tag => "v0.2.2",
      :revision => "ee55825b695fce94a337ab6a2009366372649d46"

  head "https://github.com/Hackerpilot/dfix.git", :shallow => false

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
