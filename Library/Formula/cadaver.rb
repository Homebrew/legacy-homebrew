require 'formula'

class Cadaver < Formula
  homepage 'http://www.webdav.org/cadaver/'
  url 'http://www.webdav.org/cadaver/cadaver-0.23.3.tar.gz'
  sha1 '4ad8ea2341b77e7dee26b46e4a8a496f1a2962cd'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'readline'
  depends_on 'neon'

  def install
    neon_prefix = Formula.factory('neon').prefix

    system "./configure", "--prefix=#{prefix}",
                          "--with-neon=#{neon_prefix}",
                          "--with-ssl"
    cd 'lib/intl' do
      system "make"
    end
    system "make install"
  end
end
