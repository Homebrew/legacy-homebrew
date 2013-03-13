require 'formula'

class Syck < Formula
  homepage 'https://wiki.github.com/indeyets/syck/'
  url 'http://cloud.github.com/downloads/indeyets/syck/syck-0.70.tar.gz'
  sha1 '30f89eba1fae0546ccfa75a9a3b865a3c8a9ac79'

  fails_with :llvm do
    build 2334
  end

  def install
    ENV.deparallelize # Not parallel safe.
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
