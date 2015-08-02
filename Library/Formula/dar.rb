class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.4.17/dar-2.4.17.tar.gz"
  sha256 "5d861c39698b77124680914741e1e40e7e9bedb3fcedc6df8d468e619479833c"

  bottle do
    sha256 "23e1c63d1796575d398c12ed4d2d30b727f4f1df015965d1decfb8fc233b9d96" => :yosemite
    sha256 "26098cdd3e59ddd9598cd71d5c018c89ba48f803eb43924a7e8cded84c768ab9" => :mavericks
    sha256 "bc09f5b9d90b75d1c98fb70887e08b3fbd325477b03f70b1837f3a3ae754b77e" => :mountain_lion
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
