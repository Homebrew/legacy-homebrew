require 'formula'

class Syck < Formula
  homepage 'https://wiki.github.com/indeyets/syck/'
  url 'http://cloud.github.com/downloads/indeyets/syck/syck-0.70.tar.gz'
  sha1 'e70ebeba684fd1fd126d912e3528115fbb2fb7be'

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
