require 'formula'
require 'find'

class Avidemux < Formula
  url 'svn://svn.berlios.de/avidemux/branches/avidemux_2.5_branch_gruntster'
  homepage 'http://developer.berlios.de/projects/avidemux/'
  version '2.5svn'

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
  depends_on 'libvorbis'
  depends_on 'libvpx'
  depends_on 'opencore-amr'
  depends_on 'xvid'
  depends_on 'x264'

  def options
    [[ '--with-debug', 'Enable debug build and disable optimization' ]]
  end

  skip_clean :all if ARGV.include? '--with-debug'

  def install
    # CMake is coded to use the .svn folder to find the revision,
    # but Homebrew doesn't copy .svn here from the cache.
    # This modifies CMakeLists.txt to look for .svn in the cache folder.
    svnp = "#{HOMEBREW_CACHE}/avidemux--svn"
    inreplace 'CMakeLists.txt', 'admGetRevision(${PROJECT_SOURCE_DIR} ADM_SUBVERSION)',
                                "admGetRevision(\"#{svnp}\" ADM_SUBVERSION)"

    # Turn off CMake's builtin app packager for the CLI that we want loose.
    inreplace 'avidemux/CMakeLists.txt', 'avidemux2_cli MACOSX_BUNDLE', 'avidemux2_cli'

    # Use an identifier that is unique to this app, following Apple's reverse endian style.
    # This keeps the settings separate for Avidemux2 and Avidemux3, in case Avidemux3 gets installed.
    inreplace 'avidemux/CMakeLists.txt', 'SET(MACOSX_BUNDLE_GUI_IDENTIFIER www.avidemux.org)',
                                         'SET(MACOSX_BUNDLE_GUI_IDENTIFIER org.avidemux.avidemux2)'


    # --------------------------------  end of Patches ----------------

    # Build the core cli application, avidemux_cli.
    # Build the core gui application, avidemux_qt4 if Qt4 is installed.
    gettext = Formula.factory('gettext')
    topp = Pathname(Dir.pwd)
    bldp = topp+'macbuild'
    plgp = topp+'plgbuild'
    mkdir bldp
    mkdir plgp
    Dir.chdir bldp
    args = std_cmake_parameters.split +
             [ "-DCMAKE_VERBOSE_MAKEFILE=false",
               "-DCMAKE_PREFIX_PATH=#{gettext.prefix}",
               "-DMAC_BUNDLE_DIR=#{bin}",
               "-DGTK=OFF",
               "-DSDL=OFF" ]
    if ARGV.include? '--with-debug' then
      ENV.no_optimization
      args << '-DCMAKE_BUILD_TYPE=Debug'
      args << "-DCMAKE_C_FLAGS_DEBUG=-ggdb3"
      args << "-DCMAKE_CXX_FLAGS_DEBUG=-ggdb3"
    end
    args << topp
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
      ln_sf "#{hasver}", "#{nonver}"     # Has to be quoted or get ENOENT
    end

    #---------------------------  End of building Core Apps ------

    # Now build the plugins.
    Dir.chdir plgp
    args = std_cmake_parameters.split +
             ["-DGTK=OFF",
              "-DSDL=OFF",
              "-DESD=OFF",
              "-DJACK=OFF",
              "-DCMAKE_VERBOSE_MAKEFILE=false",
              "-DCMAKE_PREFIX_PATH=#{gettext.prefix}",
              "-DMAC_BUNDLE_DIR=#{bin}",
              "-DAVIDEMUX_LIB_DIR=#{lib}",
              "-DAVIDEMUX_SOURCE_DIR=#{topp}",
              "-DAVIDEMUX_INSTALL_PREFIX=#{prefix}",
              "-DAVIDEMUX_CORECONFIG_DIR=#{bldp}/config" ]
    if ARGV.include? '--with-debug' then
      args << '-DCMAKE_BUILD_TYPE=Debug'
      args << "-DCMAKE_C_FLAGS_DEBUG=-ggdb3"
      args << "-DCMAKE_CXX_FLAGS_DEBUG=-ggdb3"
    end
    args << topp+'plugins'
    system "cmake", *args
    system "make"

    # Each dylib created by this build gets install_name_tool run on it to change
    # the internal name of the dylib so it uses the Cellar prefix.  Two dylibs need
    # to have their internal deps modified to include the Cellar prefix.  This fixes
    # the cmake install code to include the Cellar prefix rather than strip it, when
    # it calls install_name_tool.  The two dylibs are only built as part of the Qt gui.
    # So check if they exist before patching them.
    fxv = 'ADM_videoEncoder/ADM_vidEnc_xvid/qt4/cmake_install.cmake'
    fx2 = 'ADM_videoEncoder/ADM_vidEnc_x264/qt4/cmake_install.cmake'
    if (File.exists? fxv and File.exists? fx2) then
      inreplace fxv, '"libADM_vidEnc_xvid.dylib"', '"${CMAKE_INSTALL_PREFIX}/lib/ADM_plugins/videoEncoder/libADM_vidEnc_xvid.dylib"'
      inreplace fx2, '"libADM_vidEnc_x264.dylib"', '"${CMAKE_INSTALL_PREFIX}/lib/ADM_plugins/videoEncoder/libADM_vidEnc_x264.dylib"'
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
    if File.exists? bin+'avidemux2.app' then
      lapp = bin+'avidemux2.app/Contents/lib'
      papp = bin+'avidemux2.app/Contents/lib/ADM_plugins'
      pcellar = lib+'ADM_plugins'
      mkdir_p lapp
      cp_r pcellar, lapp
      Find.find(papp) do |afile|
        rm afile if File.fnmatch('*cli.dylib', afile)
      end
    end
  end

  def caveats
    <<-EOS.undent
      The command line program named avidemux2_cli is always built.
      The Qt gui named avidemux2 is built if Qt is installed.
      The program location is:
          #{bin}
    EOS
  end

  def test
    system "#{bin}/avidemux2_cli --help"
  end
end
