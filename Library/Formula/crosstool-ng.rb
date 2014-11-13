require 'formula'

class CrosstoolNg < Formula
  homepage 'http://crosstool-ng.org'
  url 'http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.20.0.tar.bz2'
  sha1 'b11f7ee706753b8cf822f98b549f8ab9dd8da9c7'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'coreutils' => :build
  depends_on 'wget'
  depends_on 'gnu-sed'
  depends_on 'gawk'
  depends_on 'binutils'
  depends_on 'libelf'
  depends_on 'homebrew/dupes/grep' => :optional
  depends_on 'homebrew/dupes/make' => :optional

  # Avoid superenv to prevent https://github.com/mxcl/homebrew/pull/10552#issuecomment-9736248
  env :std

  # Patch to fix clang offsetof. Can be removed when adopted upstream.
  # http://patchwork.ozlabs.org/patch/400328/
  patch do
    url "http://patchwork.ozlabs.org/patch/400328/raw/"
    sha1 "0baca77c863e6876f6fb1838db9e5cb60c6fe89c"
  end

  # Patch to make regex BSD grep compatible. Can be removed when adopted upstream.
  # http://patchwork.ozlabs.org/patch/400351/
  patch do
    url "http://patchwork.ozlabs.org/patch/400351/raw/"
    sha1 "8f8e29aa149e65c2588a2d9ec3849d0ba727e0ad"
  end

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

