class Wimlib < Formula
  homepage "http://sourceforge.net/projects/wimlib/"
  url "https://downloads.sourceforge.net/project/wimlib/wimlib-1.8.1.tar.gz"
  sha256 "1558fe63243984259685eb35608631cf445042ac8d1998de8c62fe85f69a15e1"

  bottle do
    cellar :any
    sha256 "f64a9c0a634b693a6229c3203b0ffb472fb04b5ee7636221f771e93f97c39425" => :yosemite
    sha256 "d6578827df535db9beec1d6b2d51edc3adb0aa59bb00ed3ed85862c0fb740cca" => :mavericks
    sha256 "800522e6a311e06f65fd83ec1049948f327df1db0975241f086a8fe177eb53d6" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "homebrew/fuse/ntfs-3g" => :optional
  depends_on "openssl"

  def install
    # fuse requires librt, unavailable on OSX
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --without-fuse
      --prefix=#{prefix}
    ]

    args << "--without-ntfs-3g" if build.without? "ntfs-3g"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"wiminfo", "--help"
  end
end
