require 'formula'

class Parmetis < Formula
  url 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.tar.gz'
  homepage 'http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview'
  sha1 'ba80786bf42a13dc5a3e0547b97971639dc58fbd'

  depends_on 'cmake' => :build

  def install
    system "make", "config", "prefix=#{prefix}"
    system 'make install'
  end
end
