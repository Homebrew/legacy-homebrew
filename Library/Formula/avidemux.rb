class Avidemux < Formula
  desc "Multiformat video editor that cuts, filters, and encodes"
  homepage "http://fixounet.free.fr/avidemux/"
  revision 1

  stable do
    url "https://downloads.sourceforge.net/avidemux/avidemux_2.6.8.tar.gz"
    sha256 "02998c235a89894d184d745c94cac37b78bc20e9eb44b318ee2bb83f2507e682"

    # remove ffmpeg binary from targets (fixed upstream)
    # http://avidemux.org/smuf/index.php/topic,16379.15.html
    patch do
      url "https://github.com/mean00/avidemux2/commit/bf0185.diff"
      sha256 "3ca5b4f1b5b3ec407a3daa5c811862ea6ed7ef6cdaaf187045e6e1c77c193800"
    end
  end

  bottle do
    revision 2
    sha256 "cf7503f021cd5b97d87f8460dedb89066be3579b0a3a32e93e6bc23eb3690528" => :el_capitan
    sha256 "0ed5eee0f130722cfbdb0768eb9e1c7d37b4acd695017ee78b03e5900d1aaca1" => :yosemite
    sha256 "e4a5d4080b67245a0632eebd798b2b1b4bae260ff4ee04b70fcbe784436041e9" => :mavericks
  end

  head do
    url "https://github.com/mean00/avidemux2.git"
    depends_on "x265"
  end

  option "with-debug", "Enable debug build."

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "yasm" => :build
  depends_on "xvid" => [:build, :recommended]
  depends_on "libvpx" => [:build, :recommended]
  depends_on "libass" => [:build, :recommended]
  depends_on "fontconfig"
  depends_on "gettext"
  depends_on "x264" => :recommended
  depends_on "faac" => :recommended
  depends_on "faad2" => :recommended
  depends_on "lame" => :recommended
  depends_on "freetype" => :recommended
  depends_on "libvorbis" => :recommended
  depends_on "opencore-amr" => :recommended
  depends_on "aften" => :recommended
  depends_on "libdca" => :recommended
  depends_on "qt" => :recommended
  depends_on "jack" => :optional
  depends_on "two-lame" => :optional
  depends_on "fribidi" => :optional
  depends_on "sdl2" => :optional

  if build.with? "sdl2"
    # fix compilation against SDL, change deprecated NSQuickDrawView to NSView
    # (submitted patch to developer via email)
    patch do
      url "https://gist.githubusercontent.com/Noctem/2c03f24daf6705964347/raw/dd6d27374e5ed44678f25b84da159ea57a9d8857/avidemux-sdl.patch"
      sha256 "17cb0181fbe503e84ad9b2762eb182ad4ec3ef8df8a90741e4f3c0e4d0a8f1ff"
    end
  end

  def install
    ENV["REV"] = version.to_s

    # For 32-bit compilation under gcc 4.2, see:
    # https://trac.macports.org/ticket/20938#comment:22
    if MacOS.version <= :leopard || (Hardware.is_32_bit? && Hardware::CPU.intel? && ENV.compiler == :clang)
      inreplace "cmake/admFFmpegBuild.cmake",
        "${CMAKE_INSTALL_PREFIX})",
        "${CMAKE_INSTALL_PREFIX} --extra-cflags=-mdynamic-no-pic)"
    end

    # Build the core
    mkdir "buildCore" do
      args = std_cmake_args
      args << "-DAVIDEMUX_SOURCE_DIR=#{buildpath}"
      args << "-DGETTEXT_INCLUDE_DIR=#{Formula["gettext"].opt_include}"
      args << "-DSDL=OFF" if build.without? "sdl2"

      if build.with? "debug"
        ENV.O2
        ENV.enable_warnings
        args << "-DCMAKE_BUILD_TYPE=Debug"
        unless ENV.compiler == :clang
          args << "-DCMAKE_C_FLAGS_DEBUG=-ggdb3"
          args << "-DCMAKE_CXX_FLAGS_DEBUG=-ggdb3"
        end
      end

      args << "../avidemux_core"
      system "cmake", *args
      # Parallel build sometimes fails with:
      #   "ld: library not found for -lADM6avcodec"
      ENV.deparallelize do
        system "make"
        system "make", "install"
      end
    end

    # UIs: Build Qt4 and cli
    interfaces = ["cli"]
    interfaces << "qt4" if build.with? "qt"
    interfaces.each do |interface|
      mkdir "build#{interface}" do
        args = std_cmake_args
        args << "-DAVIDEMUX_SOURCE_DIR=#{buildpath}"
        args << "-DAVIDEMUX_LIB_DIR=#{lib}"
        args << "-DSDL=OFF" if build.without? "sdl2"
        args << "../avidemux/#{interface}"
        system "cmake", *args
        system "make"
        system "make", "install"
      end
    end

    # Plugins
    plugins = ["COMMON", "CLI"]
    plugins << "QT4" if build.with? "qt"
    plugins.each do |plugin|
      mkdir "buildplugin#{plugin}" do
        args = std_cmake_args + %W[
          -DPLUGIN_UI=#{plugin}
          -DAVIDEMUX_LIB_DIR=#{lib}
          -DAVIDEMUX_SOURCE_DIR=#{buildpath}
        ]

        if build.with? "debug"
          args << "-DCMAKE_BUILD_TYPE=Debug"
          unless ENV.compiler == :clang
            args << "-DCMAKE_C_FLAGS_DEBUG=-ggdb3"
            args << "-DCMAKE_CXX_FLAGS_DEBUG=-ggdb3"
          end
        end

        args << "../avidemux_plugins"
        system "cmake", *args
        system "make"
        system "make", "install"
      end
    end

    # Steps from the bootStrapOsx.bash:
    app = prefix/"Avidemux2.6.app/Contents"
    mkdir_p app/"Resources"
    mkdir_p app/"MacOS"
    cp_r "./cmake/osx/Avidemux2.6", app/"MacOS/Avidemux2.6.app"
    chmod 0755, app/"MacOS/Avidemux2.6.app"
    if build.with? "qt"
      qt_opt = Formula["qt"].opt_lib
      cp_r "#{qt_opt}/QtGui.framework/Resources/qt_menu.nib", app/"MacOS/"
    end
    cp "./cmake/osx/Info.plist", app
    (app/"Resources").install_symlink bin, lib
    cp Dir["./cmake/osx/*.icns"], app/"Resources/"
  end

  def caveats
    if build.with? "qt" then <<-EOS.undent
      To enable sound: In preferences, set the audio to CoreAudio instead of Dummy.
      EOS
    end
  end

  test do
    system "#{bin}/avidemux_cli", "--help"
  end
end
