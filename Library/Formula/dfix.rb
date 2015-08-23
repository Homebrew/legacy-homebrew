class Dfix < Formula
  desc "Auto-upgrade tool for D source code"
  homepage "https://github.com/Hackerpilot/dfix"
  url "https://github.com/Hackerpilot/dfix.git",
      :tag => "v0.2.2",
      :revision => "ee55825b695fce94a337ab6a2009366372649d46"

  bottle do
    sha256 "8aa48fd6d6cfa91d379c46b6dee96d67845d127e123e0d227452a61c8933bd4a" => :yosemite
    sha256 "1f7b5aa8773e5bece8cbd9cf7c2d2f6fe4feae19e5fd1c1951c5424dc5c35881" => :mavericks
    sha256 "3d5160b13731c4645a467e05336bf12a9b0d89c9bfa188f11075abb007bebc63" => :mountain_lion
  end

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
