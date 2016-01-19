class Tevent < Formula
  desc "Event system based on the talloc memory management library"
  homepage "https://tevent.samba.org/"
  url "https://www.samba.org/ftp/tevent/tevent-0.9.21.tar.gz"
  sha256 "f2be7463573dab2d8210cb57fe7e7e2aeb323274cbdc865a6e29ddcfb977f0f4"

  bottle do
    sha256 "2dc415bc072024c5622353209f6152cb0bd53f3c06ef5a8d8135e72b039cfebf" => :el_capitan
    sha256 "38ca3de750b6780750dede4dd2bfca0b82a59c1aeafb0d015d1d3feacdaa68cd" => :yosemite
    sha256 "c10819d2919f83d948f9974a5e2c9d5667eff7ae1f9558dd726369de56f9f832" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "talloc"

  conflicts_with "samba", :because => "both install `include/tevent.h`"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-rpath",
                          "--without-gettext",
                          "--bundled-libraries=!talloc"
    system "make", "install"
  end
end
