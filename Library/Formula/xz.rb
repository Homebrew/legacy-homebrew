require 'formula'

class Xz < Formula
  homepage 'http://tukaani.org/xz/'
  url 'http://tukaani.org/xz/xz-5.0.4.tar.bz2'
  sha256 '5cd9b060d3a1ad396b3be52c9b9311046a1c369e6062aea752658c435629ce92'

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
