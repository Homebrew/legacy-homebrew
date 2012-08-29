require 'formula'

class Parmetis < Formula
  url 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.tar.gz'
  homepage 'http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview'
  md5 '856dbbd43c12d97cb6a0dc583e6361d5'

  depends_on 'cmake' => :build

  def install
    system "make", "config", "prefix=#{prefix}"
    system 'make install'
  end
end
