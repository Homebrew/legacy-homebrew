require 'formula'

class NordugridArc < Formula
  homepage 'http://www.nordugrid.org'
  url 'http://download.nordugrid.org/packages/nordugrid-arc/releases/2.0.1/src/nordugrid-arc-2.0.1.tar.gz'
  sha1 '897ae70f8cfb7fedfeb73ce95e7eee685615eb2f'

  depends_on 'pkg-config' => :build
  depends_on :libtool
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'glibmm'
  depends_on 'libxml2'
  depends_on 'globus-toolkit'

  fails_with :clang do
    build 421
    cause "Fails with 'template specialization requires 'template<>''"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
