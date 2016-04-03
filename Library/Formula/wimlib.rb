class Wimlib < Formula
  desc "Library to create, extract, and modify Windows Imaging files"
  homepage "https://wimlib.net/"
  url "https://wimlib.net/downloads/wimlib-1.9.1.tar.gz"
  sha256 "5466209f221919d091357667cf5a3c8b73ffc973972fce1c3aa96de6bd0cd014"

  bottle do
    cellar :any
    sha256 "73a97fab7cfb00de8aa963043b6315eefc10311daed952bf6fe2abc152989b2d" => :el_capitan
    sha256 "aa799af72c20285be49a7a2bb4f048583f8fe185238d42f81890d9534ad2a10d" => :yosemite
    sha256 "7e23174758d3f59d9b9f3d7adc14c43f373d7d9adc700d8e2c311c1af13e8e7f" => :mavericks
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
