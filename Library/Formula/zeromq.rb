require 'formula'

class Zeromq < Formula
  homepage 'http://www.zeromq.org/'
  url 'http://download.zeromq.org/zeromq-4.0.4.tar.gz'
  sha1 '2328014e5990efac31390439b75c5528e38e4490'

  bottle do
    cellar :any
    sha1 "6760a4e1b2091ae81c5cb909a43bb9829e7540df" => :mavericks
    sha1 "de92da055c50391f5e96cc48ab69694a906813cc" => :mountain_lion
    sha1 "c367bd8f3e75637206d2217b19516d6442060057" => :lion
  end

  head do
    url 'https://github.com/zeromq/libzmq.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end


  option :universal
  option 'with-pgm', 'Build with PGM extension'

  depends_on 'pkg-config' => :build
  depends_on 'libpgm' if build.with? "pgm"
  depends_on 'libsodium' => :optional

  def install
    ENV.universal_binary if build.universal?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    if build.with? "pgm"
      # Use HB libpgm-5.2 because their internal 5.1 is b0rked.
      ENV['OpenPGM_CFLAGS'] = %x[pkg-config --cflags openpgm-5.2].chomp
      ENV['OpenPGM_LIBS'] = %x[pkg-config --libs openpgm-5.2].chomp
      args << "--with-system-pgm"
    end

    args << "--with-libsodium" if build.with? 'libsodium'

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    To install the zmq gem on 10.6 with the system Ruby on a 64-bit machine,
    you may need to do:

        ARCHFLAGS="-arch x86_64" gem install zmq -- --with-zmq-dir=#{opt_prefix}
    EOS
  end
end
