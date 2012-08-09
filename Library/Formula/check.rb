require 'formula'

class Check < Formula
  homepage 'http://check.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/check/check/0.9.8/check-0.9.8.tar.gz'
  md5 '5d75e9a6027cde79d2c339ef261e7470'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
