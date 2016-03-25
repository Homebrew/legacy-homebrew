class Exif < Formula
  desc "Read, write, modify, and display EXIF data on the command-line"
  homepage "http://libexif.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libexif/exif/0.6.21/exif-0.6.21.tar.gz"
  sha256 "1e2e40e5d919edfb23717308eb5aeb5a11337741e6455c049852128a42288e6d"

  bottle do
    cellar :any
    sha256 "607827dc887cae86a2bedc7892e4d061990cb04814fb0ac2fd5d0cd1fdefcb30" => :el_capitan
    sha256 "ebf412bb43ad3695f01f8ed1e5851e7c02218589fc7cbb175c9a3f1914894e37" => :yosemite
    sha256 "e24a0bdfee07a46a49620c29726748e73a4eca0937c59c1f5efeeb51ea9f6971" => :mavericks
    sha256 "0d5997d1d013822aee275d0e65403a1d99b579f53c2ee131b5b121d85377665d" => :mountain_lion
  end

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
