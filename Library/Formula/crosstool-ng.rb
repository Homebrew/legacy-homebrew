class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "http://crosstool-ng.org"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.21.0.tar.bz2"
  sha256 "67122ba42657da258f23de4a639bc49c6ca7fe2173b5efba60ce729c6cce7a41"

  bottle do
    cellar :any
    sha1 "e0b4f5c33aea34c2c94cfbbb71b9e238ab5262c9" => :yosemite
    sha1 "dc3c1243bb2df823e0db44562e6dc2b869f0a3b1" => :mavericks
    sha1 "fc2cfb94d4edb31624c5703c07e536e7becb2fa0" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "coreutils" => :build
  depends_on "wget"
  depends_on "gnu-sed"
  depends_on "gawk"
  depends_on "binutils"
  depends_on "libelf"
  depends_on "homebrew/dupes/grep" => :optional
  depends_on "homebrew/dupes/make" => :optional

  # Avoid superenv to prevent https://github.com/mxcl/homebrew/pull/10552#issuecomment-9736248
  env :std

  def install
    args = ["--prefix=#{prefix}",
            "--exec-prefix=#{prefix}",
            "--with-objcopy=gobjcopy",
            "--with-objdump=gobjdump",
            "--with-readelf=greadelf",
            "--with-libtool=glibtool",
            "--with-libtoolize=glibtoolize",
            "--with-install=ginstall",
            "--with-sed=gsed",
            "--with-awk=gawk"]

    args << "--with-grep=ggrep" if build.with? "grep"

    args << "--with-make=gmake" if build.with? "make"

    args << "CFLAGS=-std=gnu89"

    system "./configure", *args

    # Must be done in two steps
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    You will need to install modern gcc compiler in order to use this tool.
    EOS
  end

  test do
    system "#{bin}/ct-ng", "version"
  end
end

