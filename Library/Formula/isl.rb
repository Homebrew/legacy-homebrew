require 'formula'

class Isl < Formula
  homepage 'http://freecode.com/projects/isl'
  # Note: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  #
  # 0.13 is out, but we can't upgrade until a compatible version of cloog is
  # released.
  url 'http://isl.gforge.inria.fr/isl-0.12.2.tar.bz2'
  sha1 'ca98a91e35fb3ded10d080342065919764d6f928'

  bottle do
    cellar :any
    revision 2
    sha1 "502db664090c83f36515b901e8a066d9ef4f0bb4" => :yosemite
    sha1 "f669eadf21a26782f4700facbec71f8d3d1dff7d" => :mavericks
    sha1 "808982b34df706187f041d7b21e644aa3d74b747" => :mountain_lion
  end

  head do
    url 'http://repo.or.cz/r/isl.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on 'gmp'

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}"
    system "make"
    system "make", "install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end
end
