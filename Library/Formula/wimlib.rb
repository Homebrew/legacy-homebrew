class Wimlib < Formula
  homepage "http://sourceforge.net/projects/wimlib/"
  url "https://downloads.sourceforge.net/project/wimlib/wimlib-1.8.1.tar.gz"
  sha256 "1558fe63243984259685eb35608631cf445042ac8d1998de8c62fe85f69a15e1"

  bottle do
    cellar :any
    sha1 "9834abd0fc78c5b6f75a9eef98414fd8084750e3" => :mavericks
    sha1 "864775795fc1f13367752c9c9d997c2362c54bcb" => :mountain_lion
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
