require 'formula'

class Povray < Formula
  homepage 'http://www.povray.org/'
  url 'https://github.com/POV-Ray/povray/archive/v3.7.0.0.tar.gz'
  sha1 '1d160d45e69d096e4c22f3b034dcc9ee94d22208'

  depends_on :macos => :lion

  depends_on :autoconf
  depends_on :automake

  depends_on :libpng
  depends_on 'boost'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'openexr' => :optional

  def patches
    {
      :p0 => [
        # Patches lseek64 => lseek
        "https://trac.macports.org/export/113876/trunk/dports/graphics/povray/files/patch-lseek64.diff",
        # Fixes configure script's stat usage, automake subdir
        "https://trac.macports.org/export/113876/trunk/dports/graphics/povray/files/patch-unix-configure.ac.diff",
        # prebuild.sh doesn't create Makefile.in properly
        "https://trac.macports.org/export/113876/trunk/dports/graphics/povray/files/patch-unix-prebuild.sh.diff",
        # missing sys/types.h header include
        "https://trac.macports.org/export/113887/trunk/dports/graphics/povray/files/patch-vfe-uint.diff"
      ],
    # Fixes some compiler warnings; comes from the upstream repo,
    # should be in next release.
      :p1 => [
        "https://github.com/POV-Ray/povray/commit/b3846f5723745e6e7926883ec6bc404922a900e6.patch",
      # Replaces references to shared_ptr with boost::shared_ptr
        "https://gist.github.com/mistydemeo/7633971/raw/ef285191f9da25aa73806d1200611b8c955ab873/boost-sharedptr.diff"
      ]
    }
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
