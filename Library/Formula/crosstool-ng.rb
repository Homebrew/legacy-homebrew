class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "http://crosstool-ng.org"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.22.0.tar.xz"
  sha256 "a8b50ddb6e651c3eec990de54bd191f7b8eb88cd4f88be9338f7ae01639b3fba"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "12da46c49731e5bdd94b3e209d86bc3a2e0fa4a26e7982a76b07a492641c5e6d" => :el_capitan
    sha256 "bce130a66509ebb9a134b1aec50abcbcc505c3d012fecd8d135b9acaf128ef01" => :yosemite
    sha256 "46ec6b65cb40a715a166aa6c4544be4028e2ac7d95ce24e15878318529133bea" => :mavericks
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
