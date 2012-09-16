require 'formula'

class Nickle < Formula
  url 'http://nickle.org/release/nickle-2.70.tar.gz'
  homepage 'http://www.nickle.org/'
  sha1 'b967e09816146e2f356c97b4fc5170a33bad2f29'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
