class Strace < Formula
  desc "A useful diagnostic, instructional, and debugging tool"
  homepage "http://sourceforge.net/projects/strace/"
  # tag "linuxbrew"

  url "https://downloads.sourceforge.net/project/strace/strace/4.10/strace-4.10.tar.xz"
  sha256 "e6180d866ef9e76586b96e2ece2bfeeb3aa23f5cc88153f76e9caedd65e40ee2"

  head "git://strace.git.sourceforge.net/gitroot/strace/strace"

  depends_on "linux-headers"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    out = `"strace" "true" 2>&1` # strace the true command, redirect stderr to output
    assert_match "execve(", out
    assert_match "+++ exited with 0 +++", out
  end
end
