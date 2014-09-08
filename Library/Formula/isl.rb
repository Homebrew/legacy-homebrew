require 'formula'

class Isl < Formula
  homepage 'http://freecode.com/projects/isl'
  # Note: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  url 'http://isl.gforge.inria.fr/isl-0.12.2.tar.bz2'
  sha1 'ca98a91e35fb3ded10d080342065919764d6f928'

  bottle do
    cellar :any
    sha1 "2d878327e26853c0f17004787233ddee9060f788" => :mavericks
    sha1 "42550979c1911f818a4a124b263be08cc094bcdf" => :mountain_lion
    sha1 "08c5044ae3bbaf9e6cf5d6329addf886430696bb" => :lion
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
