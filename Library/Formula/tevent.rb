class Tevent < Formula
  desc "Event system based on the talloc memory management library"
  homepage "http://tevent.samba.org/"
  url "http://www.samba.org/ftp/tevent/tevent-0.9.21.tar.gz"
  sha256 "f2be7463573dab2d8210cb57fe7e7e2aeb323274cbdc865a6e29ddcfb977f0f4"

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
