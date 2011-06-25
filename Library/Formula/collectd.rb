require 'formula'

class Collectd < Formula
  url 'http://collectd.org/files/collectd-5.0.0.tar.bz2'
  homepage 'http://collectd.org/'
  md5 '7bfea6e82d35b36f16d1da2c71397213'

  depends_on 'pkg-config' => :build

  skip_clean :all

  def install
    # Use system Python; doesn't compile against 2.7
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--with-python=/usr/bin",
            "--prefix=#{prefix}",
            "--localstatedir=#{var}"]
    args << "--disable-embedded-perl" if MacOS.leopard?

    system "./configure", *args
    system "make install"
  end
end
