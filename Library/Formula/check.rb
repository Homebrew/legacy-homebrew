require 'formula'

class Check < Formula
  url 'http://snapshots.aelius.com/check/check-0.9.8-20110416.tar.gz'
  homepage 'http://check.sourceforge.net/'
  md5 'cd549cd714b01315ead37418f15f5f0d'

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
