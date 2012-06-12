require 'formula'

class Cadaver < Formula
  homepage 'http://www.webdav.org/cadaver/'
  url 'http://www.webdav.org/cadaver/cadaver-0.23.3.tar.gz'
  sha1 '4ad8ea2341b77e7dee26b46e4a8a496f1a2962cd'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-included-neon",
                          "--with-ssl"
    cd 'lib/intl' do
      system "make"
    end
    system "make install"
  end
end
