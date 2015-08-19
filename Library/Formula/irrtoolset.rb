class Irrtoolset < Formula
  desc "Tools to work with Internet routing policies"
  homepage "http://irrtoolset.isc.org/"
  url "http://ftp.isc.org/isc/IRRToolSet/IRRToolSet-5.0.1/irrtoolset-5.0.1.tar.gz"
  sha256 "c044e4e009bf82db84f6a4f4d5ad563b07357f2d0e9f0bbaaf867e9b33fa5e80"

  head do
    url "svn://irrtoolset.isc.org/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  def install
    if build.head?
      system "glibtoolize"
      system "autoreconf -i"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/peval", "ANY"
  end
end
