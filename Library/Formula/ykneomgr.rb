require 'formula'

class Ykneomgr < Formula
  homepage 'https://developers.yubico.com/libykneomgr/'
  url 'https://developers.yubico.com/libykneomgr/Releases/libykneomgr-0.1.6.tar.gz'
  sha1 '9e0d39544421788223baaea176c3ecafc4290589'

  head do
    url 'https://github.com/Yubico/libykneomgr.git'
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gengetopt" => :build
  end

  option :universal

  depends_on "help2man" => :build  # <- not supposed to, but it does
  depends_on "pkg-config" => :build
  depends_on 'libzip'

  def install
    ENV.universal_binary if build.universal?

    system "make", "autoreconf" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end
end
