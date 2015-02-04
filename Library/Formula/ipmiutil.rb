require 'formula'

class Ipmiutil < Formula
  homepage 'http://ipmiutil.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-2.9.5.tar.gz'
  sha1 '265f022c876da373b2ecb4be2bc0f98e65f70977'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sha256",
                          "--enable-gpl"

    system "make", "TMPDIR=#{ENV['TMPDIR']}"
    # DESTDIR is needed to make everything go where we want it.
    system "make", "prefix=/",
                   "DESTDIR=#{prefix}",
                   "varto=#{var}/lib/#{name}",
                   "initto=#{etc}/init.d",
                   "sysdto=#{prefix}/#{name}",
                   "install"
  end

  test do
    system "#{bin}/ipmiutil", "delloem", "help"
  end
end
