class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "http://wimlib.net"
  url "http://wimlib.net/downloads/wimlib-1.8.2.tar.gz"
  sha256 "b3e269f124c5b69d945f9d17077d53d517d431f6b46c614221a85c3e4501ecdf"

  bottle do
    cellar :any
    sha256 "e4fcc65b657a3f3dfc95d5dfeb2cb5e321d8254fe756c9bfee23338c3ef63d8e" => :yosemite
    sha256 "3a1e8a6d63b7d553222c9f18d92b5b35e34075b5af6d534bdf70be04f30dfb9a" => :mavericks
    sha256 "d8843f2da9fbe075fe7a10a726a808530a77714828afc4dbbd719ccf6f5c7ccb" => :mountain_lion
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
