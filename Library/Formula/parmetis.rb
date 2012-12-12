require 'formula'

class Parmetis < Formula
  homepage 'http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview'
  url 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.2.tar.gz'
  sha1 '1699453f0bd2ffed34e5a755dec92048d797476d'

  depends_on 'cmake' => :build
  depends_on MPIDependency.new(:cc)

  def install
    system "make", "config", "prefix=#{prefix}"
    system 'make install'
  end
end
