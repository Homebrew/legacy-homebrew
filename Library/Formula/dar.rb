class Dar < Formula
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.4.17/dar-2.4.17.tar.gz"
  sha256 "5d861c39698b77124680914741e1e40e7e9bedb3fcedc6df8d468e619479833c"

  bottle do
    sha1 "e7320da542a160fbad03ccec820e671d3db2312e" => :mavericks
    sha1 "e1ecd4f0f946d0672c3d7733911455daf474a621" => :mountain_lion
    sha1 "072c3583b7e85feb5685a28ebcecf37428158fe1" => :lion
  end

  option "with-docs", "build programming documentation (in particular libdar API documentation) and html man page"
  option "with-libgcrypt", "enable strong encryption support"
  option "with-lzo", "enable lzo compression support"
  option "with-upx", "make executables compressed at installation time"

  if build.with? "docs"
    depends_on "coreutils" => :build
    depends_on "doxygen" => :build
  end

  depends_on "gettext" => :optional
  depends_on "gnu-sed" => :build
  depends_on "libgcrypt" => :optional
  depends_on "lzo" => :optional
  depends_on "upx" => [:build, :optional]

  def install
    ENV.prepend_path "PATH", "#{Formula["gnu-sed"].opt_libexec}/gnubin"
    ENV.prepend_path "PATH", "#{Formula["coreutils"].opt_libexec}/gnubin" if build.with? "docs"
    ENV.libstdcxx if ENV.compiler == :clang && MacOS.version >= :mavericks

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-dar-static
      --prefix=#{prefix}
    ]

    args << "--disable-build-html" if build.without? "docs"
    args << "--disable-libgcrypt-linking" if build.without? "libgcrypt"
    args << "--disable-liblzo2-linking" if build.without? "lzo"
    args << "--disable-upx" if build.without? "upx"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
