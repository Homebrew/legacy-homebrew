class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.8.2.tar.gz"
  sha256 "b3e269f124c5b69d945f9d17077d53d517d431f6b46c614221a85c3e4501ecdf"

  bottle do
    cellar :any
    revision 1
    sha256 "cb4fe3d53c27732d2d84a21bbb9c4574b82f901c1ac5cf5c6a167b3afe87d63b" => :el_capitan
    sha256 "4feb16b0df781bfd61e7ddef268ae4ef804c4dd9a945153d71ca022149a512cc" => :yosemite
    sha256 "b256df14024b19238dafec26877eb22ea09c7562accd8c44322280d2e001880b" => :mavericks
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
    # make a directory containing a dummy 1M file
    mkdir("foo")
    system "dd", "if=/dev/random", "of=foo/bar", "bs=1m", "count=1"

    # capture an image
    ENV.append "WIMLIB_IMAGEX_USE_UTF8", "1"
    system "#{bin}/wimcapture", "foo", "bar.wim"
    assert File.exist?("bar.wim")

    # get info on the image
    system "#{bin}/wiminfo", "bar.wim"
  end
end
