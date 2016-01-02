class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.4.7/imlib2-1.4.7.tar.bz2"
  sha256 "35d733ce23ad7d338cff009095d37e656cb8a7a53717d53793a38320f9924701"

  bottle do
    revision 1
    sha256 "bc2f73214d81c88fe174132f70347b3c2a971fef8f26cbca91e17e4765cd9c80" => :el_capitan
    sha256 "44eb001751aeffc39b81a51b672fbada43f0c0b711c238882fa145e4a0daaa45" => :yosemite
    sha256 "9f74024ffd21ca15fadef0213b9f79149a32125984dee6aa712605cb6e5a21df" => :mavericks
  end

  deprecated_option "without-x" => "without-x11"

  depends_on "freetype"
  depends_on "libpng" => :recommended
  depends_on :x11 => :recommended
  depends_on "pkg-config" => :build
  depends_on "jpeg" => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-amd64=no
    ]
    args << "--without-x" if build.without? "x11"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
