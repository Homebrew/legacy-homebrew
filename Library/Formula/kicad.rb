class Kicad < Formula
  desc "Electronic Design Automation Suite"
  homepage "http://www.kicad-pcb.org"
  url "https://launchpad.net/kicad/4.0/4.0.0-rc1/+download/kicad-4.0.0-rc1.tar.xz"
  sha256 "62c2e95a2d6b8a3cf30bb91146c3d2b1c0df0cbfc070b6e54bcfdf0da2df6973"
  head "https://github.com/KiCad/kicad-source-mirror.git"

  option "without-menu-icons", "Build without icons menus."
  option "without-python", "Disables python scriptability."

  depends_on "swig" => :build
  depends_on "pkg-config" => :build
  depends_on "bazaar" => :build
  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "pcre"
  depends_on "openssl"
  depends_on "glew"
  depends_on "boost"
  depends_on :python => :recommended

  fails_with :gcc
  fails_with :llvm

  # KiCad requires wx to have several bugs fixed to function, but the patches have yet to be included with a wx release
  # so KiCad, as part of its build system, builds its own wx binaries with these fixes included.  It uses a bash script
  # for this, so I have simply concatenated all the patches into one patch to make it fit better into homebrew.  These
  # Patches are the ones that come from the stable release archive of KiCad under the patches directory.
  resource "wxpatch" do
    url "https://gist.githubusercontent.com/metacollin/2d5760743df73c939d53/raw/b25008a92c8f518df582ad88d266dcf2d75f9d12/wxp.patch"
    sha256 "0a19c475ded29186683a9e7f7d9316e4cbea4db7b342f599cee0e116fa019f3e"
  end

  resource "wxk" do
    url "https://downloads.sourceforge.net/project/wxpython/wxPython/3.0.2.0/wxPython-src-3.0.2.0.tar.bz2"
    sha256 "d54129e5fbea4fb8091c87b2980760b72c22a386cb3b9dd2eebc928ef5e8df61"
  end

  resource "kicad-library" do
    url "https://github.com/KiCad/kicad-library.git"
  end

  def install
    ENV["MAC_OS_X_VERSION_MIN_REQUIRED"] = "#{MacOS.version}"
    ENV.append "ARCHFLAGS", "-Wunused-command-line-argument-hard-error-in-future"
    ENV.append "LDFLAGS", "-headerpad_max_install_names"
    if MacOS.version < :mavericks
      ENV.libstdcxx
    else
      ENV.libcxx
    end

    inreplace "common/common.cpp", "/Library/Application Support/kicad", "#{etc}/kicad"
    inreplace "common/common.cpp", "wxStandardPaths::Get().GetUserConfigDir()", "wxT( \"#{etc}/kicad/Prefences\" )"
    inreplace "common/pgm_base.cpp", "DEFAULT_INSTALL_PATH", "\"#{etc}/kicad\""

    resource("wxk").stage do
      (Pathname.pwd).install resource("wxpatch")
      safe_system "/usr/bin/patch", "-g", "0", "-f", "-d", Pathname.pwd, "-p1", "-i", "wxp.patch"

      mkdir "wx-build" do
        args = [
          "--prefix=#{buildpath/"wxk"}",
          "--with-opengl",
          "--enable-aui",
          "--enable-utf8",
          "--enable-html",
          "--enable-stl",
          "--with-libjpeg=builtin",
          "--with-libpng=builtin",
          "--with-regex=builtin",
          "--with-libtiff=builtin",
          "--with-zlib=builtin",
          "--with-expat=builtin",
          "--without-liblzma",
          "--with-macosx-version-min=#{MacOS.version}",
          "--enable-universal_binary=i386,x86_64",
          "CC=#{ENV.cc}",
          "CXX=#{ENV.cxx}",
        ]

        system "../configure", *args
        system "make"
        system "make", "install"
      end

      if build.with? "python"
        cd "wxPython" do
          args = [
            "WXPORT=osx_cocoa",
            "WX_CONFIG=#{buildpath/"wxk"}/bin/wx-config",
            "UNICODE=1",
            "BUILD_BASE=#{buildpath}/wx-build",
          ]

          system "python", "setup.py", "build_ext", *args
          system "python", "setup.py", "install", "--prefix=#{buildpath}/py", *args
        end
      end
    end

    mkdir "build" do
      if build.with? "python"
        ENV.prepend_create_path "PYTHONPATH", "#{buildpath}/py/lib/python2.7/site-packages"
      end

      args = %W[
        -DCMAKE_INSTALL_PREFIX=#{prefix}
        -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
        -DwxWidgets_CONFIG_EXECUTABLE=#{buildpath/"wxk"}/bin/wx-config
        -DKICAD_REPO_NAME=brewed_product
        -DKICAD_SKIP_BOOST=ON
        -DBoost_USE_STATIC_LIBS=ON
      ]

      if build.with? "debug"
        args << "-DCMAKE_BUILD_TYPE=Debug"
        args << "-DwxWidgets_USE_DEBUG=ON"
      else
        args << "-DCMAKE_BUILD_TYPE=Release"
      end

      if build.with? "python"
        args << "-DPYTHON_SITE_PACKAGE_PATH=#{buildpath}/py/lib/python2.7/site-packages"
        args << "-DKICAD_SCRIPTING=ON"
        args << "-DKICAD_SCRIPTING_MODULES=ON"
        args << "-DKICAD_SCRIPTING_WXPYTHON=ON"
        ENV["PYTHON_EX"] = which "python"
        args << "-DPYTHON_EXECUTABLE=#{ENV["PYTHON_EX"]}"
      else
        args << "-DKICAD_SCRIPTING=OFF"
        args << "-DKICAD_SCRIPTING_MODULES=OFF"
        args << "-DKICAD_SCRIPTING_WXPYTHON=OFF"
      end
      args << "-DCMAKE_C_COMPILER=#{ENV.cc}"
      args << "-DCMAKE_CXX_COMPILER=#{ENV.cxx}"

      if build.with? "menu-icons"
        args << "-DUSE_IMAGES_IN_MENUS=ON"
      end

      system "cmake", "../", *(std_cmake_args + args)
      system "make"
      system "make", "install"
    end

    resource("kicad-library").stage do
      mkdir_p "#{etc}/kicad/Preferences" do
        (etc/"kicad").install Dir["*"]
      end
    end
  end

  def caveats; <<-EOS.undent
    KiCad component libraries are located in:
      /usr/local/etc/kicad

    KiCad footprint table is located at:
      /usr/local/etc/kicad/Preferences/fp-lib-table

    Component libraries have been setup for you, but
    footprints and 3D models must be downloaded from
    within Pcbnew.  It will automatically guide you
    through this process upon first lauch.
    EOS
  end

  test do
    system "stat", "#{prefix}/kicad.app/Contents/MacOS/kicad"
  end
end
