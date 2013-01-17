require 'formula'

class NordugridArc < Formula
  homepage 'http://www.nordugrid.org'
  url 'http://download.nordugrid.org/packages/nordugrid-arc/releases/2.0.0/src/nordugrid-arc-2.0.0.tar.gz'
  sha1 '9ce4f060993c172390211144c818f93461aff7ec'

  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'glibmm'
  depends_on 'libxml2'
  depends_on 'globus-toolkit'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      Fails with 'template specialization requires 'template<>''
      EOS
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
