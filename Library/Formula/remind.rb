require 'formula'

class Remind < Formula
  homepage 'http://www.roaringpenguin.com/products/remind'
  url 'http://www.roaringpenguin.com/files/download/remind-03.01.13.tar.gz'
  sha1 'dce46b2334b3849255feffe6cba4973f3c883647'

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
