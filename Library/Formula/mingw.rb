class Mingw < Formula
  def arch
    if Hardware::CPU.type == :intel
      if MacOS.prefer_64_bit?
        "x86_64"
      else
        "i686"
      end
    elsif Hardware::CPU.type == :ppc
      if MacOS.prefer_64_bit?
        "powerpc64"
      else
        "powerpc"
      end
    end
  end

  def osmajor
    `uname -r`.chomp
  end

  desc "Minimalist GNU for Windows"
  homepage "http://www.mingw.org/"
  url "http://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v3.1.0.tar.bz2"
  mirror "http://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/mingw-w64-v3.1.0.tar.bz2/download?use_mirror=kent"
  sha256 "ece7a7e7e1ab5e25d5ce469f8e4de7223696146fffa71c16e2a9b017d0e017d2"

  head "svn://gcc.gnu.org/svn/gcc/trunk"

  resource "gcc48" do
    url "http://ftpmirror.gnu.org/gcc/gcc-4.8.5/gcc-4.8.5.tar.bz2"
    sha256 "22fb1e7e0f68a63cee631d85b20461d1ea6bda162f03096350e38c8d427ecf23"
  end


  #option "with-java", "Build the gcj compiler"
  #option "with-all-languages", "Enable all compilers and languages, except Ada"
  # option "with-nls", "Build with native language support (localization)"
  #option "with-jit", "Build the jit compiler"
  #option "without-fortran", "Build without the gfortran compiler"
  # enabling multilib on a host that can't run 64-bit results in build failures
  #option "without-multilib", "Build without multilib support" if MacOS.prefer_64_bit?

  depends_on "gmp4"
  depends_on "gcc48" => ["with-all-languages"]
  depends_on "binutils"
  depends_on "isl011"
  depends_on "isl012"
  depends_on "cloog018"

  def install
    args = [
      "--with-isl=#{Formula["isl011"].opt_prefix}",
      "--with-cloog=#{Formula["cloog018"].opt_prefix}",
      "--target=i686-w64-mingw32",
      "--disable-multilib",
      "--with-gmp=#{Formula["gmp4"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr2"].opt_prefix}",
      "--with-system-zlib",
      "--enable-version-specific-runtime-libs",
      "--with-mpc=#{Formula["libmpc08"].opt_prefix}",
      #--with-mpc=/usr/local/Cellar/libmpc08/0.8.1/ \
      "--enable-libstdcxx-time=yes",
      "--enable-stage1-checking",
      "--enable-checking=release",
      "--enable-lto",
      "--enable-threads=win32",
      "--disable-sjlj-exceptions",
      # --prefix=$PREFIX --with-sysroot=$PREFIX
    ]

    # I think mingw make will do this for us
    # mkdir "build-headers64" do
    #   # Install Headers
    #   system "../mingw-w64-headers/configure",
    #          "--host=x86_64-w64-mingw32",
    #          "--prefix=#{buildpath}/x86_64-w64-mingw32"
    #   system "make", "-j4"
    #   system "make", "install-strip"
    #   system "find", "."
    # end

    mkdir "build-headers64" do
      # install headers
      system "../mingw-w64-headers/configure",
             "--host=x86_64-w64-mingw32",
             "--prefix=#{buildpath}/x86_64-w64-mingw32"
      system "make", "-j4"
      system "make", "install-strip"
      #system "make", "install"
      system "find", "#{buildpath}"
    end

    mkdir "build-crt64" do
      system "../mingw-w64-crt/configure",
             "--host=x86_64-w64-mingw32",
             "--prefix=#{buildpath}/x86_64-w64-mingw32",
             "--with-sysroot=#{buildpath}"
      system "make"
      system "make", "install"
    end

    mkdir "build64" do
      # Might need to rebuild binutils first...

      system "../configure",
             "--host=x86_64-w64-mingw32",
             "--prefix=#{buildpath}/x86_64-w64-mingw32"
      system "make"
      system "make", "install-strip"

    end

  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

end
