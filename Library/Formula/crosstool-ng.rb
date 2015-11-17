class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "http://crosstool-ng.org"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.21.0.tar.bz2"
  sha256 "67122ba42657da258f23de4a639bc49c6ca7fe2173b5efba60ce729c6cce7a41"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f267314a1d8ebc6234b09801a10d30e342045e35bf8e81788dd79ebaf7667c1" => :el_capitan
    sha256 "fbc3920e7189b2c7e637890d60df8289b89cc0b2be8dc0bae8c9fdc8bcf35191" => :yosemite
    sha256 "1c3efe8b7bb00129838870fabb44db60767ea2831ce2e705ada924fc5ea9e66e" => :mavericks
    sha256 "15d5c1e9803492e947c3649796ffb405324e7573a4b6a1cf64f6b5412808346d" => :mountain_lion
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

