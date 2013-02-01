require 'formula'

class Check < Formula
  homepage 'http://check.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/check/check/0.9.9/check-0.9.9.tar.gz'
  sha1 '96c06ff9971884628c2512f0e3bca6141c49290b'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
