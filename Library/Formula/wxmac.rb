require 'formula'

class FrameworkPython < Requirement
  fatal true
  env :userpaths

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
  url 'http://sourceforge.net/projects/wxpython/files/wxPython/2.9.4.0/wxPython-src-2.9.4.0.tar.bz2'
  sha1 'c292cd45b51e29c558c4d9cacf93c4616ed738b9'

  option 'no-python', 'Do not build Python bindings'

  depends_on FrameworkPython unless build.include? "no-python"

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
      ENV.append_to_cflags '-arch x86_64' if MacOS.prefer_64_bit?

      system "python", "setup.py",
                       "build_ext",
                       "WXPORT=osx_cocoa",
                       *args
      system "python", "setup.py",
                       "install",
                       "--prefix=#{prefix}",
                       "WXPORT=osx_cocoa",
                       *args
    end
  end

  def install
    # need to set with-macosx-version-min to avoid configure defaulting to 10.5
    args = [
      "--disable-debug",
      "--prefix=#{prefix}",
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
      "--with-macosx-version-min=#{MacOS.version}"
    ]

    system "./configure", *args
    system "make install"

    unless build.include? "no-python"
      ENV['WXWIN'] = Dir.getwd
      # We have already downloaded wxPython in a bundle with wxWidgets
      install_wx_python
    end
  end

  def caveats
    s = ''
    fp = FrameworkPython.new
    unless build.include? 'no-python' or fp.satisfied?
      s += fp.message
    end

    return s
  end
end
