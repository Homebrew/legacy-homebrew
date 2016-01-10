class Twemcache < Formula
  desc "Twitter fork of memcached"
  homepage "https://github.com/twitter/twemcache"
  url "https://github.com/twitter/twemcache/archive/v2.6.2.tar.gz"
  sha256 "49905ceb89bf5d0fde25fa4b8843b2fe553915c0dc75c813de827bd9c0c85e26"
  head "https://github.com/twitter/twemcache.git"

  bottle do
    cellar :any
    sha256 "8257030de4e6251c2899c235cf860b8aae1def40922d0ebd474bba5b92133982" => :el_capitan
    sha256 "458cedc005b03da5a0dbbc2bdc916b30f04b1dc37916dbcaf38b6270712b4bd2" => :yosemite
    sha256 "4489ad8862e470f2c9ccab1bdf5ac072ab42133283a6f89b4f2cd831af902e67" => :mavericks
  end

  option "with-debug", "Debug mode with assertion panics enabled"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent"

  def install
    args = %W[--prefix=#{prefix}]

    if build.with? "debug"
      ENV.O0
      ENV.append "CFLAGS", "-ggdb3"
      args << "--enable-debug=full"
    end

    system "autoreconf", "-fvi"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"twemcache", "--help"
  end
end
