require 'formula'

class Libdrizzle < Formula
  head 'bzr://https://launchpad.net/libdrizzle/trunk'
  url 'http://launchpad.net/libdrizzle/trunk/0.7/+download/libdrizzle-0.7.tar.gz'
  homepage 'https://launchpad.net/libdrizzle'
  md5 '9b2f0ed5d9f63d0f0b9253d03c817d55'

  def install
    system "./config/autorun.sh" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
