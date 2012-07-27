require 'formula'

class Ipopt < Formula
  homepage 'https://projects.coin-or.org/Ipopt'
  url 'http://www.coin-or.org/download/source/Ipopt/Ipopt-3.10.0.tgz'
  md5 '10d934a58b54dcc58c6ebee34ca437bb'

  depends_on 'pkg-config' => :build

  def install
    ENV.fortran
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize # Needs a serialized install
    system "make install"
  end
end
