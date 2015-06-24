class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "http://www.zeromq.org/"

  bottle do
    cellar :any
    sha256 "35959e6b6e357d80c35529f410a7429cb53ed0d79d56762c8719ce822dab8431" => :yosemite
    sha256 "54649139f4cdd17a5780335eda37286feecfed5b5682fd15782b9e4895d14380" => :mavericks
    sha256 "78951bbe1bb821bdc758ba28ec3220acc6ea85b228250c348120760f7cc45841" => :mountain_lion
  end

  head do
    url "https://github.com/zeromq/libzmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  stable do
    url "http://download.zeromq.org/zeromq-4.1.2.tar.gz"
    sha1 "86c17096f7f4bf46cbcd2ad242cf8fec8a7cfb7b"
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
      ENV['pgm_CFLAGS'] = %x[pkg-config --cflags openpgm-5.2].chomp
      ENV['pgm_LIBS'] = %x[pkg-config --libs openpgm-5.2].chomp
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
