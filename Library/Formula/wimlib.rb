class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.9.0.tar.gz"
  sha256 "a7e3636222d7eac76fbf7da42f8e30e2eb02739d930815a4b16be898c9f6bd14"

  bottle do
    cellar :any
    sha256 "40a6a46238ed4f03c5d7452025a4e3e7c0c5baf894d709af3759f041a4cbaeb4" => :el_capitan
    sha256 "55505d54bd707ee2acab64c2637bb5949a6ac4e4fc0b5e399c9a6894822012b0" => :yosemite
    sha256 "7941c8b30aa61a331dcf692149c2a36609919f28216652972bc04173dbcbad0b" => :mavericks
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
