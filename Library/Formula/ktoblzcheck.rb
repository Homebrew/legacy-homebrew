class Ktoblzcheck < Formula
  desc "Library for German banks"
  homepage "http://ktoblzcheck.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.48.tar.gz"
  sha256 "0f4e66d3a880355b1afc88870d224755e078dfaf192242d9c6acb8853f5bcf58"

  bottle do
    sha1 "9575535aa28c130cd738edce67a6cc95789dcf10" => :yosemite
    sha1 "59920a94f3347e9954e8ca692730fc48900224c2" => :mavericks
    sha1 "ce8c954020e3436d57983d7be273a5c9b1070313" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make", "install"
  end

  test do
    assert_match /Ok/, shell_output("#{bin}/ktoblzcheck --outformat=oneline 10000000 123456789", 0)
    assert_match /unknown/, shell_output("#{bin}/ktoblzcheck --outformat=oneline 12345678 100000000", 3)
  end
end
