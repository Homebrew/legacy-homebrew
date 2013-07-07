require 'formula'

class Xz < Formula
  homepage 'http://tukaani.org/xz/'
  url 'http://tukaani.org/xz/xz-5.0.5.tar.gz'
  mirror 'http://fossies.org/linux/misc/xz-5.0.5.tar.gz'
  sha256 '5dcffe6a3726d23d1711a65288de2e215b4960da5092248ce63c99d50093b93a'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
