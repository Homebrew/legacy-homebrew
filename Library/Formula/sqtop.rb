class Sqtop < Formula
  homepage "https://github.com/paleg/sqtop"
  url "https://github.com/paleg/sqtop/archive/v2015-02-08.tar.gz"
  version "2015-02-08"
  sha1 "379a97e0190f3da39e2d67096955c40217b39ae5"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/sqtop --help")
  end
end
