require 'formula'

class Ipopt < Formula
  url 'http://www.coin-or.org/download/source/Ipopt/Ipopt-3.9.2.tgz'
  homepage 'https://projects.coin-or.org/Ipopt'
  md5 'a8787bc3ee28ec2236630ddf0ca2065e'


  def install
    ENV.fortran
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
