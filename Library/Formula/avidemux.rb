require 'formula'
require 'find'

class Avidemux < Formula
  homepage 'http://avidemux.sourceforge.net/'
  url 'http://downloads.sourceforge.net/avidemux/avidemux_2.5.6.tar.gz'
  sha1 '47205c236bf6a4435b9d4dd944493c7b7e2752f5'

  head 'http://svn.berlios.de/svnroot/repos/avidemux/branches/avidemux_2.5_branch_gruntster'

  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build
  depends_on 'yasm' => :build
  depends_on 'gettext'
  depends_on 'aften'
  depends_on 'mad'
  depends_on 'lame'
  depends_on 'faad2'
  depends_on 'faac'
  depends_on 'a52dec'
  depends_on 'libdca'
  depends_on 'libogg'
  depends_on 'libvpx'
  depends_on 'libvorbis'
  depends_on 'opencore-amr'
  depends_on 'xvid'
  depends_on 'x264'

  # Check if this still exists @ XCode-4.3.4 or 4.4.0.  I think it's fixed then
  # by llvm in clang svn.  So this will have to persist for older clang.
  fails_with :clang do
    build 318
    cause "error in backend: Couldn't allocate input reg for constraint"
  end unless ARGV.include? '--with-debug'

  def options
    [[ '--with-debug', 'Enable debug build.' ]]
  end

  def patches
    # Symbols undefined due to optimization.  Fixed in head. Remove @ 2.5.7.
    DATA if Hardware.is_32_bit? and not ARGV.build_head?
  end

  def install
    # Avidemux is coded to use the .svn or .git directory to find its revision,
    # but neither vcs copies those during clone from the cache to the stagedir.
    # Modify cmake/admMainChecks.cmake to look in the Homebrew cache.
    if ARGV.build_head? then
      inreplace 'CMakeLists.txt',
        'admGetRevision(${PROJECT_SOURCE_DIR} ADM_SUBVERSION)',
        "admGetRevision(\"#{cached_download}\" ADM_SUBVERSION)"
    end

    # Turn off CMake's builtin app packager for the CLI that we want loose.
    inreplace 'avidemux/CMakeLists.txt',
        'avidemux2_cli MACOSX_BUNDLE',
        'avidemux2_cli'

    # Use an identifier that is unique to this app following Apple style.
    inreplace 'avidemux/CMakeLists.txt',
                'SET(MACOSX_BUNDLE_GUI_IDENTIFIER www.avidemux.org)',
                'SET(MACOSX_BUNDLE_GUI_IDENTIFIER org.avidemux.avidemux2)'

    # For 32-bit compilation under gcc 4.2, see:
    # http://trac.macports.org/ticket/20938#comment:22
    if MacOS.leopard? or Hardware.is_32_bit?
      inreplace 'cmake/admFFmpegBuild.cmake',
        '${CMAKE_INSTALL_PREFIX})',
        '${CMAKE_INSTALL_PREFIX} --extra-cflags=-mdynamic-no-pic)'
    end


    # Build the core.
    gettext = Formula.factory('gettext')
    mkdir 'corebuild' do
      args = std_cmake_parameters.split + %W[
        -DCMAKE_PREFIX_PATH=#{gettext.prefix}
        -DMAC_BUNDLE_DIR=#{prefix}
        -DGTK=OFF
        -DSDL=OFF
      ]
      if ARGV.include? '--with-debug' then
        (ENV.compiler == :clang) ? ENV.Og : ENV.O2
        ENV.deparallelize
        ENV.remove_from_cflags '-w'
        args << '-DCMAKE_BUILD_TYPE=Debug'
        args << '-DCMAKE_VERBOSE_MAKEFILE=true'
        args << '-DCMAKE_C_FLAGS_DEBUG=-ggdb3' if ENV.compiler != :clang
        args << '-DCMAKE_CXX_FLAGS_DEBUG=-ggdb3' if ENV.compiler != :clang
      end
      args << buildpath
      system "cmake", *args
      system "make"
      system "make install"

      # g++ links the core applications against unversioned dylibs
      # from an internal ffmpeg, even though CMake specifies versioned
      # dylibs. CMake then installs the versioned ffmpeg dylibs only.
      # This patch creates the missing symlinks for unversioned libs.
      #   * The lib version numbers are either one or two digits.
      #   * The version numbers change every couple of months.
      #   * So this finds the file first, then makes a symlink.
      #   * The result of this code is a command like this:
      #       ln_sf lib+'libADM5avcodec.53.dylib', lib+'libADM5avcodec.dylib'
      ffpref = 'libADM5'
      ffsuff = '.dylib'
      %w{ avcodec avformat avutil postproc swscale }.each do |fflib|
        ffpat = ffpref+fflib+'.{?,??}'+ffsuff
        ffpat = lib+ffpat
        nonver = ffpref+fflib+ffsuff
        nonver = lib+nonver
        hasver = Dir[ffpat]
        ln_sf hasver.to_s, nonver.to_s
      end
    end

    mkdir 'plugbuild' do
      args = std_cmake_parameters.split + %W[
        -DGTK=OFF
        -DSDL=OFF
        -DESD=OFF
        -DJACK=OFF
        -DCMAKE_PREFIX_PATH=#{gettext.prefix}
        -DMAC_BUNDLE_DIR=#{prefix}
        -DAVIDEMUX_LIB_DIR=#{lib}
        -DAVIDEMUX_SOURCE_DIR=#{buildpath}
        -DAVIDEMUX_INSTALL_PREFIX=#{prefix}
        -DAVIDEMUX_CORECONFIG_DIR=#{buildpath}/corebuild/config
      ]
      if ARGV.include? '--with-debug' then
        args << '-DCMAKE_BUILD_TYPE=Debug'
        args << '-DCMAKE_VERBOSE_MAKEFILE=true'
        args << '-DCMAKE_C_FLAGS_DEBUG=-ggdb3' if ENV.compiler != :clang
        args << '-DCMAKE_CXX_FLAGS_DEBUG=-ggdb3' if ENV.compiler != :clang
      end
      args << "#{buildpath}/plugins"
      system "cmake", *args
      system "make"

      # Two dylibs that are only built as part of the Qt gui need an RPATH
      # set on their internal deps. Check if they exist before patching them.
      # A patch to introduce RPATH use upstream is being fashioned.
      fxv = 'ADM_videoEncoder/ADM_vidEnc_xvid/qt4/cmake_install.cmake'
      fx2 = 'ADM_videoEncoder/ADM_vidEnc_x264/qt4/cmake_install.cmake'
      if (File.exists? fxv and File.exists? fx2) then
        inreplace fxv,
          '"libADM_vidEnc_xvid.dylib"',
          '"${CMAKE_INSTALL_PREFIX}/lib/ADM_plugins/videoEncoder/libADM_vidEnc_xvid.dylib"'
        inreplace fx2,
          '"libADM_vidEnc_x264.dylib"',
          '"${CMAKE_INSTALL_PREFIX}/lib/ADM_plugins/videoEncoder/libADM_vidEnc_x264.dylib"'
      end

      system "make install"

      # The post-build code to finalize the Qt app using BundleUtilities()
      # was never finished, and does not work atm.  So do these manually
      # if the Qt gui was built:
      #   1. The plugin loading code looks for plugins in two places:
      #         ../lib
      #         ~/.plugins
      #   2. So create a lib directory in the .app, one level up.
      #   3. and copy all the plugins we made to it,
      #   4. but omit any plugins that are for the CLI only.
      #   5. CLI only files end in cli.dylib.
      if File.exists? prefix+'avidemux2.app' then
        app_lib_path = prefix+'avidemux2.app/Contents/lib'
        app_plug_path = prefix+'avidemux2.app/Contents/lib/ADM_plugins'
        cellar_plug_path = lib+'ADM_plugins'
        mkdir_p app_lib_path
        cp_r cellar_plug_path, app_lib_path
        Find.find(app_plug_path) do |f|
          rm f if File.fnmatch('*cli.dylib', f)
        end
      end
    end # of plugbuild
  end

  def caveats
    <<-EOS.undent
      The command line program avidemux2_cli gets installed in your PATH.
      The Qt gui is installed if you have Qt4, and its location is
          #{prefix}/avidemux2.app
      You can double-click it in Finder or link it into ~/Applications with
          brew linkapps
    EOS
  end
end

__END__
--- a/avidemux/ADM_core/include/ADM_mangle.h    2011-12-28 16:32:37.000000000 -0800
+++ b/avidemux/ADM_core/include/ADM_mangle.h    2012-04-07 10:49:11.000000000 -0700
@@ -26,7 +26,7 @@
 #    else
 #        define MANGLE(a) "_" #a
 #        define FUNNY_MANGLE(x) __attribute__((used)) x asm(MANGLE(x))
-#        define FUNNY_MANGLE_ARRAY(x, y) x[y] asm(MANGLE(x))
+#        define FUNNY_MANGLE_ARRAY(x, y) __attribute__((used)) x[y] asm(MANGLE(x))
 #    endif
 #else
 #    if defined(ADM_CPU_X86_64) && defined(PIC)
