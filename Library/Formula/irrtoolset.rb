require 'formula'

class Irrtoolset < Formula
  homepage 'http://irrtoolset.isc.org/'
  url 'http://ftp.isc.org/isc/IRRToolSet/IRRToolSet-5.0.1/irrtoolset-5.0.1.tar.gz'
  sha1 '19510275f5f64608e4a683c744c14f8e900ea19e'
  head 'svn://irrtoolset.isc.org/trunk'

  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'pkg-config' => :build

  def install
    if build.head?
      system "glibtoolize"
      system "autoreconf -i"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/peval", "ANY"
  end
end
