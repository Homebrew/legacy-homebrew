require 'formula'

class Metis < Formula
  url 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.0.2.tar.gz'
  homepage 'http://glaros.dtc.umn.edu/gkhome/views/metis'
  sha1 'b5a278fa06c581e068a8296d158576a4b750f983'

  depends_on 'cmake' => :build

  def install
    system "make", "config", "prefix=#{prefix}"
    system "make install"
  end
end
