require 'formula'

class Remind < Formula
  homepage 'http://www.roaringpenguin.com/products/remind'
  url 'http://www.roaringpenguin.com/files/download/remind-03.01.12.tar.gz'
  sha1 '0978357014916e0c5259e18b845d291eeb367b6c'

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
