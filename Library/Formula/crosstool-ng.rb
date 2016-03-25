class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "http://crosstool-ng.org"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.22.0.tar.xz"
  sha256 "a8b50ddb6e651c3eec990de54bd191f7b8eb88cd4f88be9338f7ae01639b3fba"

  bottle do
    cellar :any_skip_relocation
    sha256 "0bb96bf1f53301c76335fd1c3a82f326d35c379a96300e1cf6a16cd921d4a77d" => :el_capitan
    sha256 "f90f1e7a0ad37de323a0b3ec6693db6efd1a3f9cedb7774ce3e92f04a25b4058" => :yosemite
    sha256 "19be1947001313166d0bb0b2a223f9f3221b341d1aab90fce5d005713b7a5a49" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "coreutils" => :build
  depends_on "help2man" => :build
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
            "--with-awk=gawk",
           ]

    args << "--with-grep=ggrep" if build.with? "grep"

    args << "--with-make=#{Formula["make"].opt_bin}/gmake" if build.with? "make"

    args << "CFLAGS=-std=gnu89"

    system "./configure", *args

    # Must be done in two steps
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    You will need to install modern gcc compiler in order to use this tool.
    EOS
  end

  test do
    system "#{bin}/ct-ng", "version"
  end
end
