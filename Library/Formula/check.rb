require 'formula'

class Check < Formula
  homepage 'http://check.sourceforge.net/'
  url 'http://snapshots.aelius.com/check/check-0.9.8-20110416.tar.gz'
  md5 'cd549cd714b01315ead37418f15f5f0d'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
