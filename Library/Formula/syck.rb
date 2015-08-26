class Syck < Formula
  desc "Extension for reading and writing YAML"
  homepage "https://wiki.github.com/indeyets/syck/"
  url "http://cloud.github.com/downloads/indeyets/syck/syck-0.70.tar.gz"
  sha256 "4c94c472ee8314e0d76eb2cca84f6029dc8fc58bfbc47748d50dcb289fda094e"

  fails_with :llvm do
    build 2334
  end

  def install
    ENV.deparallelize # Not parallel safe.
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
