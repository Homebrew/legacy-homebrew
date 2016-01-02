class Ktoblzcheck < Formula
  desc "Library for German banks"
  homepage "http://ktoblzcheck.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.48.tar.gz"
  sha256 "0f4e66d3a880355b1afc88870d224755e078dfaf192242d9c6acb8853f5bcf58"

  bottle do
    sha256 "fdae7050c9000d7793a336a9baa3f3903922d385fe9cf8d0c61ca5c08f595520" => :yosemite
    sha256 "7a9fda64f86b9762bb98e48299a0d35884f6d1163f8ed8647db9764ad9b76a9c" => :mavericks
    sha256 "176bf59fd3b5cedac348101b150d2e13e33c08798d838a6ad3af50091ab6531a" => :mountain_lion
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
