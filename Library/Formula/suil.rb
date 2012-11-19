require 'formula'

class Suil < Formula
  homepage 'http://drobilla.net/software/suil/'
  url 'http://download.drobilla.net/suil-0.6.6.tar.bz2'
  sha1 '50fd1b1c7e8ca000f36752d827d9212c459092ef'

  depends_on 'pkg-config' => :build

  def install
    system "./waf configure --prefix=#{prefix}"
    system "./waf"
    system "./waf install"
  end
end
