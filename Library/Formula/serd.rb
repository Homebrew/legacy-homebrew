require 'formula'

class Serd < Formula
  homepage 'http://drobilla.net/software/serd/'
  url 'http://download.drobilla.net/serd-0.18.2.tar.bz2'
  sha1 '9472be8d6f407affca5c8fa3125a5fbe49af967e'

  depends_on 'pkg-config' => :build

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
