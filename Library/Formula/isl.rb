require 'formula'

class Isl < Formula
  homepage 'http://freecode.com/projects/isl'
  # Note: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  url 'http://isl.gforge.inria.fr/isl-0.12.1.tar.bz2'
  sha1 'a54e80a32bc3e06327053d77d6a81516d4f4b21f'

  bottle do
    sha1 '45240d08c107cb30c012ef7821e540114096e26c' => :mountain_lion
    sha1 '0a7bad8d98bd5da3ff66116f7b4f4a8d49d180ad' => :lion
    sha1 '547196582a38df80c78f3953254cfa6db3641507' => :snow_leopard
  end

  head do
    url 'http://repo.or.cz/r/isl.git'

    depends_on :autoconf => :build
    depends_on :automake => :build
    depends_on :libtool => :build
  end

  depends_on 'gmp'

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula.factory("gmp").opt_prefix}"
    system "make"
    system "make", "install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end
end
