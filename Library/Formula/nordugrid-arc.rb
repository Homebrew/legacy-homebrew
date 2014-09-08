require 'formula'

class NordugridArc < Formula
  homepage 'http://www.nordugrid.org'
  url 'http://download.nordugrid.org/packages/nordugrid-arc/releases/4.2.0/src/nordugrid-arc-4.2.0.tar.gz'
  sha1 'b372034bd40c41a725ad91512835bd4e267b68aa'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'glibmm'
  depends_on 'libxml2'
  depends_on 'globus-toolkit'

  fails_with :clang do
    build 500
    cause "Fails with 'template specialization requires 'template<>''"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-swig",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    (testpath/'foo').write('data')
    system "#{bin}/arccp", "foo", "bar"
  end
end
