class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "http://www.zeromq.org/"
  url "http://download.zeromq.org/zeromq-4.1.4.tar.gz"
  sha256 "e99f44fde25c2e4cb84ce440f87ca7d3fe3271c2b8cfbc67d55e4de25e6fe378"

  bottle do
    cellar :any
    sha256 "a0875f5b8256eafaf86e311046a2321edcb7af829db59cc6bb8c2ef6a3d26886" => :el_capitan
    sha256 "0bf4140e81b230f09ce7e2f4cffc54c8343c0ef99526770f782336d2225567ab" => :yosemite
    sha256 "b3fdd2f17ea70e3f9ea2d3363d141b0b7eb73fe65f480dd24400bdf0ddbd8ccd" => :mavericks
  end

  head do
    url "https://github.com/zeromq/libzmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal
  option "with-libpgm", "Build with PGM extension"
  option "with-norm", "Build with NORM extension"

  deprecated_option "with-pgm" => "with-libpgm"

  depends_on "pkg-config" => :build
  depends_on "libpgm" => :optional
  depends_on "libsodium" => :optional
  depends_on "norm" => :optional

  def install
    ENV.universal_binary if build.universal?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    if build.with? "libpgm"
      # Use HB libpgm-5.2 because their internal 5.1 is b0rked.
      ENV["pgm_CFLAGS"] = `pkg-config --cflags openpgm-5.2`.chomp
      ENV["pgm_LIBS"] = `pkg-config --libs openpgm-5.2`.chomp
      args << "--with-pgm"
    end

    if build.with? "libsodium"
      args << "--with-libsodium"
    else
      args << "--without-libsodium"
    end

    args << "--with-norm" if build.with? "norm"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <zmq.h>

      int main()
      {
        zmq_msg_t query;
        assert(0 == zmq_msg_init_size(&query, 1));
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzmq", "-o", "test"
    system "./test"
  end
end
