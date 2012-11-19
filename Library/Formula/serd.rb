require 'formula'

class Serd < Formula
  homepage 'http://drobilla.net/software/serd/'
  url 'http://download.drobilla.net/serd-0.18.0.tar.bz2'
  sha1 'd8bcf81631196d814cfea018101fc64745e334e3'

  depends_on 'pkg-config' => :build

  def install
    system "./waf configure --prefix=#{prefix}"
    system "./waf"
    system "./waf install"
  end
end
