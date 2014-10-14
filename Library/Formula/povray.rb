require 'formula'

class Povray < Formula
  homepage 'http://www.povray.org/'
  url 'https://github.com/POV-Ray/povray/archive/v3.7.0.0.tar.gz'
  sha1 '1d160d45e69d096e4c22f3b034dcc9ee94d22208'
  revision 1

  depends_on :macos => :lion
  depends_on :autoconf
  depends_on :automake
  depends_on 'libpng'
  depends_on 'boost'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'openexr' => :optional

  # Patches lseek64 => lseek
  patch :p0 do
    url "https://trac.macports.org/export/113876/trunk/dports/graphics/povray/files/patch-lseek64.diff"
    sha1 "c033cf8b8ac1ff6ea6be1778250ea532b280be99"
  end

  # Fixes configure script's stat usage, automake subdir
  patch :p0 do
    url "https://trac.macports.org/export/113876/trunk/dports/graphics/povray/files/patch-unix-configure.ac.diff"
    sha1 "61444d4391c62e90935ddcc845f0c05fd4feac3b"
  end

  # prebuild.sh doesn't create Makefile.in properly
  patch :p0 do
    url "https://trac.macports.org/export/113876/trunk/dports/graphics/povray/files/patch-unix-prebuild.sh.diff"
    sha1 "52eefd89818d5aac58e67e5f9dfc74853cbc65e6"
  end

  # missing sys/types.h header include
  patch :p0 do
    url "https://trac.macports.org/export/113887/trunk/dports/graphics/povray/files/patch-vfe-uint.diff"
    sha1 "da064ef1046184f4b4caa770d6ff9a5abb0d3f94"
  end

  # Fixes some compiler warnings; comes from the upstream repo, should be in next release.
  patch do
    url "https://github.com/POV-Ray/povray/commit/b3846f5723745e6e7926883ec6bc404922a900e6.diff"
    sha1 "2266b17c984fe7cceee6c99f6bb9dd83bc179106"
  end

  # Replaces references to shared_ptr with boost::shared_ptr
  patch do
    url "https://gist.githubusercontent.com/mistydemeo/7633971/raw/ef285191f9da25aa73806d1200611b8c955ab873/boost-sharedptr.diff"
    sha1 "8d38908f41eab4da61d1d892ee030bff0bfefeaa"
  end

  def install
    # include the boost system library to resolve compilation conflicts
    ENV["LIBS"] = "-lboost_system-mt -lboost_thread-mt"

    args = [
      "COMPILED_BY=homebrew",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--mandir=#{man}",
    ]

    args << "--with-openexr=${HOMEBREW_PREFIX}" if build.include? "use-openexr"

    cd 'unix' do
      system "./prebuild.sh"
    end

    system "./configure", *args
    system "make install"
  end

  test do
    ohai "Rendering all test scenes; this may take a while"
    system "#{share}/povray-3.7/scripts/allscene.sh", "-o", "."
  end
end
