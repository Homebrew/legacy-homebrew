require 'formula'
# adapted from the wxmac formula but now uses the wxWidgets included in (and patchted by) wxPython!

def which_python
  if ARGV.include? '--system-python'
    '/usr/bin/python'
  else
    'python'
  end
end

class Wxpython < Formula
  url 'http://sourceforge.net/projects/wxpython/files/wxPython/2.9.2.4/wxPython-src-2.9.2.4.tar.bz2'
  head 'http://svn.wxwidgets.org/svn/wx/wxPython/trunk/', 
    :using => StrictSubversionDownloadStrategy
  md5 '8dae829b3bb3ccfe279d5d3948562c5f'
  homepage 'http://www.wxpython.org'

  def options
    [
      ['--system-python', 'Build against the OS X Python instead of whatever is in the path.'],
      ['--universal', 'Universal i386 and x86_64'],
    ]
  end

  def install_wx_python
    opts = [
      # Reference our wx-config
      "WX_CONFIG=#{bin}/wx-config",
      # Enable OpenGl, if pyopengl is installed.
      "BUILD_GLCANVAS=1",
      "WXPORT=osx_cocoa"
    ]
    Dir.chdir "wxPython" do
      system         which_python,
                     "setup.py",
                     "build_ext",
                     *opts

      system         which_python,
                     "setup.py",
                     "install",
                     "--prefix=#{prefix}",
                     *opts
    end
  end

  def install
  
  
    system "./configure", "--disable-debug",
                          "--with-osx_cocoa",
                          "--prefix=#{prefix}",
                          "--enable-unicode",
                          "--with-macosx-sdk=/Developer/SDKs/MacOSX10.6.sdk", # Thanks over to our friends at https://trac.macports.org/ticket/30272
                          "--with-macosx-version-min=10.6", # also needed to fix "utils_osx.cpp:72: error: ‘CGDisplayBitsPerPixel’ was not declared in this scope"
                          "--with-opengl",
                          "--with-libjpeg",
	                        "--with-libtiff",
	                        "--with-libpng",
	                        "--with-zlib",
	                        "--enable-dnd",
	                        "--enable-clipboard",
	                        "--enable-webkit",
	                        "--enable-svg",
	                        "--with-expat"
    system "make install"

    ENV['WXWIN'] = Dir.getwd
    Wxpython.new.brew { install_wx_python }
  end

  def caveats
    s = <<-EOS.undent
      This version from the 2.9 series uses cocoa and works for 64bit systems.
      Not yet a stable release. Be warned.

      This formula conflicts with wxmac, since wxpython builds a patched (bundled)
      version of wxWidgets.

      Python bindings require that Python be built as a Framework; this is the
      default for Mac OS provided Python but not for Homebrew python (brew install
      python using the --framework option).
      EOS

    return s
  end
end
