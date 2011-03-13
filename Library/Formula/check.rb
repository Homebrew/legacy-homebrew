require 'formula'

class Check < Formula
  url 'http://downloads.sourceforge.net/project/check/check/0.9.8/check-0.9.8.tar.gz'
  homepage 'http://check.sourceforge.net/'
  md5 '5d75e9a6027cde79d2c339ef261e7470'

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.include? "--universal"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
