require 'formula'

class Remind < Formula
  url 'http://www.roaringpenguin.com/files/download/remind-03.01.12.tar.gz'
  homepage 'http://www.roaringpenguin.com/products/remind'
  md5 'de16cbfc3ee94defcb1abdf78b2ebcd1'

  def install
    # Remove unnecessary sleeps when running on Apple
    inreplace "configure", "sleep 1", "true"
    inreplace "src/init.c" do |s|
      s.gsub! "sleep(5);", ""
      s.gsub! /rkrphgvba\(.\);/, ""
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
