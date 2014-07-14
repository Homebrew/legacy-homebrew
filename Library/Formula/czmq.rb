require 'formula'

class Czmq < Formula
  homepage 'http://czmq.zeromq.org/'
  url 'http://download.zeromq.org/czmq-2.2.0.tar.gz'
  sha1 '2f4fd8de4cf04a68a8f6e88ea7657d8068f472d2'

  head do
    url 'https://github.com/zeromq/czmq.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  option :universal

  depends_on 'zeromq'

  def install
    ENV.universal_binary if build.universal?
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    rm Dir["#{bin}/*.gsl"]
  end

  test do
    bin.cd do
      system "#{bin}/czmq_selftest"
    end
  end
end
