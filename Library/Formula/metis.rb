require 'formula'

class Metis < Formula
  url 'http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.0.2.tar.gz'
  homepage 'http://glaros.dtc.umn.edu/gkhome/views/metis'
  md5 'acb521a4e8c2e6dd559a7f9abd0468c5'

  depends_on 'cmake' => :build

  def install
    system "make", "config", "prefix=#{prefix}"
    system "make install"
  end
end
