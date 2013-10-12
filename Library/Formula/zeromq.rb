require 'formula'

class Zeromq < Formula
  homepage 'http://www.zeromq.org/'
  url 'http://download.zeromq.org/zeromq-3.2.4.tar.gz'
  sha1 '08303259f08edd1faeac2e256f5be3899377135e'

  head do
    url 'https://github.com/zeromq/libzmq.git'

    depends_on :automake
    depends_on :libtool
  end


  option :universal
  option 'with-pgm', 'Build with PGM extension'

  depends_on 'pkg-config' => :build
  depends_on 'libpgm' if build.include? 'with-pgm'

  def install
    ENV.universal_binary if build.universal?

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    if build.include? 'with-pgm'
      # Use HB libpgm-5.2 because their internal 5.1 is b0rked.
      ENV['OpenPGM_CFLAGS'] = %x[pkg-config --cflags openpgm-5.2].chomp
      ENV['OpenPGM_LIBS'] = %x[pkg-config --libs openpgm-5.2].chomp
      args << "--with-system-pgm"
    end

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
