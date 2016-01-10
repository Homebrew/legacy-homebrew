class Libevent < Formula
  desc "Asynchronous event library"
  homepage "http://libevent.org"
  url "https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz"
  sha256 "71c2c49f0adadacfdbe6332a372c38cf9c8b7895bb73dabeaa53cdcc1d4e1fa3"

  bottle do
    cellar :any
    sha256 "968c69226279617bd8abc9641c602706e184ad8fab99275675070cf65a99d3eb" => :el_capitan
    sha256 "a7d3b12f1159fdb17ad77cf323a83fd7a0b961f6ec90f56129aa70e067d24557" => :yosemite
    sha256 "fe2eac7bcc675e5fddc5df9a9ff1428ec666d1aac495b363410a28c8dd2fe86f" => :mavericks
    sha256 "2dfd0517ff3a0065bc07d742ae2fe44075cb99a33bffa4cb88a5bff886d630d3" => :mountain_lion
  end

  head do
    url "https://github.com/libevent/libevent.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "doxygen" => [:optional, :build]
  depends_on "pkg-config" => :build
  depends_on "openssl"

  option :universal
  option "with-doxygen", "Build and install the manpages (using Doxygen)"

  deprecated_option "enable-manpages" => "with-doxygen"

  fails_with :llvm do
    build 2326
    cause "Undefined symbol '_current_base' reported during linking."
  end

  conflicts_with "pincaster",
    :because => "both install `event_rpcgen.py` binaries"

  def install
    ENV.universal_binary if build.universal?
    ENV.j1

    if build.with? "doxygen"
      inreplace "Doxyfile", /GENERATE_MAN\s*=\s*NO/, "GENERATE_MAN = YES"
    end

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug-mode",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    if build.with? "doxygen"
      system "make", "doxygen"
      man3.install Dir["doxygen/man/man3/*.3"]
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <event2/event.h>

      int main()
      {
        struct event_base *base;
        base = event_base_new();
        event_base_free(base);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-levent", "-o", "test"
    system "./test"
  end
end
