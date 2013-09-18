require 'formula'

class FrameworkPython < Requirement
  fatal true

  satisfy do
    q = `python -c "import distutils.sysconfig as c; print(c.get_config_var('PYTHONFRAMEWORK'))"`
    not q.chomp.empty?
  end

  def message
    "Python needs to be built as a framework."
  end
end

class Wxmac < Formula
  homepage 'http://www.wxwidgets.org'
  url 'http://downloads.sourceforge.net/project/wxpython/wxPython/2.9.5.0/wxPython-src-2.9.5.0.tar.bz2'
  sha1 '9183b2ffc6631cb2551c51b655a9d08904aa7b52'

  option 'disable-monolithic', "Build a non-monolithic library (split into multiple files)"
  depends_on :python => :recommended
  depends_on FrameworkPython if build.with? "python"

  def install_wx_python
    args = [
      # Reference our wx-config
      "WX_CONFIG=#{bin}/wx-config",
      # At this time Wxmac is installed Unicode only
      "UNICODE=1",
      # Some scripts (e.g. matplotlib) expect to `import wxversion`, which is
      # only available on a multiversion build. Besides that `import wx` still works.
      "INSTALL_MULTIVERSION=1",
      # OpenGL and stuff
      "BUILD_GLCANVAS=1",
      "BUILD_GIZMOS=1",
      "BUILD_STC=1"
    ]
    cd "wxPython" do
      ENV.append_to_cflags "-arch #{MacOS.preferred_arch}"

      python do
        system python, "setup.py",
                       "build_ext",
                       "WXPORT=osx_cocoa",
                       *args
        system python, "setup.py",
                       "install",
                       "--prefix=#{prefix}",
                       "WXPORT=osx_cocoa",
                       *args
      end
    end
  end

  def install
    # need to set with-macosx-version-min to avoid configure defaulting to 10.5
    # need to enable universal binary build in order to build all x86_64 headers
    # need to specify x86_64 and i386 or will try to build for ppc arch and fail on newer OSes
    # https://trac.macports.org/browser/trunk/dports/graphics/wxWidgets30/Portfile#L80
    ENV.universal_binary
    args = [
      "--disable-debug",
      "--prefix=#{prefix}",
      "--enable-shared",
      "--enable-unicode",
      "--enable-std_string",
      "--enable-display",
      "--with-opengl",
      "--with-osx_cocoa",
      "--with-libjpeg",
      "--with-libtiff",
      "--with-libpng",
      "--with-zlib",
      "--enable-dnd",
      "--enable-clipboard",
      "--enable-webkit",
      "--enable-svg",
      "--with-expat",
      "--with-macosx-version-min=#{MacOS.version}",
      "--with-macosx-sdk=#{MacOS.sdk_path}",
      "--enable-universal_binary=#{Hardware::CPU.universal_archs.join(',')}",
      "--disable-precomp-headers"
    ]
    args << "--enable-monolithic" unless build.include? 'disable-monolithic'

    system "./configure", *args
    system "make install"

    if build.with? "python"
      ENV['WXWIN'] = Dir.getwd
      # We have already downloaded wxPython in a bundle with wxWidgets
      install_wx_python
    end
  end

  def caveats
    s = ''
    fp = FrameworkPython.new
    unless build.without? 'python' or fp.satisfied?
      s += fp.message
    end

    return s
  end
end
