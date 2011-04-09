require 'formula'

class Collectd < Formula
  url 'http://collectd.org/files/collectd-4.10.2.tar.bz2'
  homepage 'http://collectd.org/'
  md5 '85d9d8d0a1327782661e3c89800aa70e'

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
