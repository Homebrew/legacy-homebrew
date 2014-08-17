require 'formula'

# Help! Wanted: someone who can get Avidemux working with SDL.

class Avidemux < Formula
  homepage 'http://fixounet.free.fr/avidemux/'
  url 'https://downloads.sourceforge.net/avidemux/avidemux_2.6.8.tar.gz'
  sha1 '50f3dfe270e6272fce46d725b198b9d0dd95664b'
  head 'git://gitorious.org/avidemux2-6/avidemux2-6.git'

  bottle do
    sha1 "5a168ebcb9661ba351bc09d734437fc93ef57cd0" => :mavericks
    sha1 "1af759be4340d3acdc1fd4158eab85a2df41cfa1" => :mountain_lion
    sha1 "07734309d8789563146619defe6c2384a3927fd2" => :lion
  end

  option 'with-debug', 'Enable debug build.'

  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build
  depends_on 'yasm' => :build
  depends_on 'fontconfig'
  depends_on 'gettext'
  depends_on 'x264' => :recommended
  depends_on 'faac' => :recommended
  depends_on 'faad2' => :recommended
  depends_on 'lame' => :recommended
  depends_on 'xvid' => :recommended
  depends_on 'freetype' => :recommended
  depends_on 'theora' => :recommended
  depends_on 'libvorbis' => :recommended
  depends_on 'libvpx' => :recommended
  depends_on 'rtmpdump' => :recommended
  depends_on 'opencore-amr' => :recommended
  depends_on 'libvo-aacenc' => :recommended
  depends_on 'libass' => :recommended
  depends_on 'openjpeg' => :recommended
  depends_on 'speex' => :recommended
  depends_on 'schroedinger' => :recommended
  depends_on 'fdk-aac' => :recommended
  depends_on 'opus' => :recommended
  depends_on 'frei0r' => :recommended
  depends_on 'libcaca' => :recommended
  depends_on 'qt' => :recommended

  def install
    ENV['REV'] = version.to_s

    # For 32-bit compilation under gcc 4.2, see:
    # http://trac.macports.org/ticket/20938#comment:22
    if MacOS.version <= :leopard or Hardware.is_32_bit? && Hardware::CPU.intel? && ENV.compiler == :clang
      inreplace 'cmake/admFFmpegBuild.cmake',
        '${CMAKE_INSTALL_PREFIX})',
        '${CMAKE_INSTALL_PREFIX} --extra-cflags=-mdynamic-no-pic)'
    end

    # Build the core
    mkdir 'buildCore' do
      args = std_cmake_args
      args << "-DAVIDEMUX_SOURCE_DIR=#{buildpath}"
      args << "-DGETTEXT_INCLUDE_DIR=#{Formula["gettext"].opt_include}"
      # Todo: We could depend on SDL and then remove the `-DSDL=OFF` arguments
      # but I got build errors about NSview.
      args << "-DSDL=OFF"

      if build.with? 'debug'
        ENV.O2
        ENV.enable_warnings
        args << '-DCMAKE_BUILD_TYPE=Debug'
        args << '-DCMAKE_VERBOSE_MAKEFILE=true'
        unless ENV.compiler == :clang
          args << '-DCMAKE_C_FLAGS_DEBUG=-ggdb3'
          args << '-DCMAKE_CXX_FLAGS_DEBUG=-ggdb3'
        end
      end

      args << '../avidemux_core'
      system "cmake", *args
      # Parallel build sometimes fails with: "ld: library not found for -lADM6avcodec"
      ENV.deparallelize
      system "make"
      system "make", "install"
      # There is no ENV.parallelize, so:
      ENV['MAKEFLAGS'] = "-j#{ENV.make_jobs}"
    end

    # UIs: Build Qt4 and cli
    interfaces = ['cli']
    interfaces << 'qt4' if build.with? 'qt'
    interfaces.each do |interface|
      mkdir "build#{interface}" do
        args = std_cmake_args
        args << "-DAVIDEMUX_SOURCE_DIR=#{buildpath}"
        args << "-DAVIDEMUX_LIB_DIR=#{lib}"
        args << "-DSDL=OFF"
        args << "../avidemux/#{interface}"
        system "cmake", *args
        system "make"
        system "make", "install"
      end
    end

    # Plugins
    plugins = ['COMMON', 'CLI']
    plugins << 'QT4' if build.with? 'qt'
    plugins.each do |plugin|
      mkdir "buildplugin#{plugin}" do
        args = std_cmake_args + %W[
          -DPLUGIN_UI=#{plugin}
          -DAVIDEMUX_LIB_DIR=#{lib}
          -DAVIDEMUX_SOURCE_DIR=#{buildpath}
        ]

        if build.with? 'debug'
          args << '-DCMAKE_BUILD_TYPE=Debug'
          args << '-DCMAKE_VERBOSE_MAKEFILE=true'
          unless ENV.compiler == :clang
            args << '-DCMAKE_C_FLAGS_DEBUG=-ggdb3'
            args << '-DCMAKE_CXX_FLAGS_DEBUG=-ggdb3'
          end
        end

        args << "../avidemux_plugins"
        system "cmake", *args
        system "make"
        system "make install"
      end
    end

    # Steps from the bootStrapOsx.bash:
    app = prefix/"Avidemux2.6.app/Contents"
    mkdir_p app/"Resources"
    mkdir_p app/"MacOS"
    cp_r "./cmake/osx/Avidemux2.6", app/"MacOS/Avidemux2.6.app"
    chmod 0755, app/"MacOS/Avidemux2.6.app"
    cp_r Formula['qt'].opt_prefix/"lib/QtGui.framework/Resources/qt_menu.nib", app/"MacOS/" if build.with? 'qt'
    cp "./cmake/osx/Info.plist", app
    (app/"Resources").install_symlink bin, lib
    cp Dir["./cmake/osx/*.icns"], app/"Resources/"
  end

  def caveats
    if build.with? 'qt' then <<-EOS.undent
      To enable sound: In preferences, set the audio to CoreAudio instead of Dummy.
      EOS
    end
  end
end
