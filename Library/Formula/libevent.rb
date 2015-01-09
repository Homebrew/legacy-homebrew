class Libevent < Formula
  homepage "http://libevent.org"
  url "https://downloads.sourceforge.net/project/levent/libevent/libevent-2.0/libevent-2.0.22-stable.tar.gz"
  sha1 "a586882bc93a208318c70fc7077ed8fca9862864"

  bottle do
    cellar :any
    sha1 "02d25e21d04bdef22de822daf70f13c90147b504" => :yosemite
    sha1 "bbf14123e381177a6423a064ff82b5b3adc3d85a" => :mavericks
    sha1 "b1de9d394f4df8561760e3c34c23bb9b518e372f" => :mountain_lion
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
