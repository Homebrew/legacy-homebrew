class Exif < Formula
  desc "Read, write, modify, and display EXIF data on the command-line"
  homepage "http://libexif.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libexif/exif/0.6.21/exif-0.6.21.tar.gz"
  sha256 "1e2e40e5d919edfb23717308eb5aeb5a11337741e6455c049852128a42288e6d"

  option "with-gettext", "Build with Native Language Support"

  depends_on "pkg-config" => :build
  depends_on "popt"
  depends_on "libexif"
  depends_on "gettext" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    args << "--disable-nls" if build.without? "gettext"

    system "./configure", *args
    system "make", "install"
  end
end
