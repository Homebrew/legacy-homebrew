class Dfix < Formula
  desc "Auto-upgrade tool for D source code"
  homepage "https://github.com/Hackerpilot/dfix"
  url "https://github.com/Hackerpilot/dfix.git",
      :tag => "v0.2.2",
      :revision => "ee55825b695fce94a337ab6a2009366372649d46"
  head "https://github.com/Hackerpilot/dfix.git", :shallow => false

  bottle do
    revision 1
    sha256 "2709dd421a14b25ccfa1b2df8b099f4dee19828dab05e5890f44aaadf28de396" => :el_capitan
    sha256 "b342cb7a7e474f1c860161bd4ccba2c7a7614fec883c6206f8b29a7c63e0ef5c" => :yosemite
    sha256 "21833c2f187417a1c559f376f07eac40d62b289319eb8a78f433d5f7ff23030b" => :mavericks
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
