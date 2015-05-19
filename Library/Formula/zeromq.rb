class Zeromq < Formula
  desc "High-performance, asynchronous messaging library"
  homepage "http://www.zeromq.org/"
  revision 2

  bottle do
    cellar :any
    sha1 "8598e6f79d5cfbe72f281c3f835c0894078108ad" => :yosemite
    sha1 "895c3427fb619cf3dcbe1d51cbf2c97d55177821" => :mavericks
    sha1 "ba066d695b43cba56747649b18f146696ba2ada0" => :mountain_lion
  end

  head do
    url "https://github.com/zeromq/libzmq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  stable do
    url "http://download.zeromq.org/zeromq-4.0.5.tar.gz"
    sha1 "a664ec63661a848ef46114029156a0a6006feecd"

    patch do
      # enable --without-libsodium on libzmq < 4.1
      # zeromq/zeromq4-x#105
      url "https://gist.githubusercontent.com/minrk/478aab66adf7016158ff/raw/b5ea2d61c3f66db6ff3e266b76d1bec4ad4a238b/without-libsodium.patch"
      sha1 "68543ff1b0f64b22994cb13b4d24bce8f76cf431"
    end
  end

  option :universal
  option "with-libpgm", "Build with PGM extension"

  deprecated_option "with-pgm" => "with-libpgm"

  depends_on "pkg-config" => :build
  depends_on "libpgm" => :optional
  depends_on "libsodium" => :optional

  def install
    ENV.universal_binary if build.universal?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    if build.with? "libpgm"
      # Use HB libpgm-5.2 because their internal 5.1 is b0rked.
      ENV['OpenPGM_CFLAGS'] = %x[pkg-config --cflags openpgm-5.2].chomp
      ENV['OpenPGM_LIBS'] = %x[pkg-config --libs openpgm-5.2].chomp
      args << "--with-system-pgm"
    end

    if build.with? "libsodium"
      args << "--with-libsodium"
    else
      args << "--without-libsodium"
    end

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
