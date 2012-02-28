require 'formula'

class Freeswitch < Formula
  homepage 'http://freeswitch.org'
  head 'git://git.freeswitch.org/freeswitch.git'
  url 'git://git.freeswitch.org/freeswitch.git', :tag => 'v1.0.6'
  version '1.0.6'
  md5 '7b73c47b2e003210845cfee22fb6c352'

  depends_on 'jpeg'

  def install
    system "./bootstrap.sh -j#{%x[sysctl -n hw.ncpu].strip}"
    system "./configure", "--enable-shared", "--enable-static",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--exec_prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "freeswitch -version"
  end
end
