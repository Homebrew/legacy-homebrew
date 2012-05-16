require 'formula'

class Wxpython < Formula
  # For 2.8, we use this separate formula for wxPython. For 2.9 we use the combined one.
  url 'http://downloads.sourceforge.net/wxpython/wxPython-src-2.8.12.1.tar.bz2'
  md5 '8c06c5941477beee213b4f2fa78be620'
  head 'http://svn.wxwidgets.org/svn/wx/wxPython/trunk/', :using => StrictSubversionDownloadStrategy
  homepage 'http://www.wxpython.org'
end

class Wxmac < Formula
  url 'http://downloads.sourceforge.net/project/wxwindows/2.8.12/wxMac-2.8.12.tar.bz2'
  md5 '876000a9a9742c3c75a2597afbcb8856'

  devel do
    # wxPython 2.9 with 64bit and cocoa support ships a (patched) wxmac:
    url 'http://sourceforge.net/projects/wxpython/files/wxPython/2.9.3.1/wxPython-src-2.9.3.1.tar.bz2'
    md5 '11f5a423c05c43b4ff8c9f11f1986f04'
  end

  homepage 'http://www.wxwidgets.org'

  def options
    [
      ['--python', 'Build Python bindings'],
      ['--devel', 'Using unstable 2.9.x series (But 64-bit & cocoa support!)']
    ]
  end

  def test_python_arch
    # wxPython 2.8 does not yet support 64bit. But 2.9 with (--devel) does!
    unless ARGV.build_devel?
      begin
        system "arch -i386 python --version"
      rescue
        onoe "No python on path or default python does not support 32-bit."
        puts <<-EOS.undent
          Your default python (if any) does not support 32-bit execution, which is
          required for the wxmac python bindings. You can install the Homebrew
          python with 32-bit support by running:

          brew install python --universal --framework

        EOS
        exit 99
      end
    end
  end

def install_wx_python
    opts = [
      # Reference our wx-config
      "WX_CONFIG=#{bin}/wx-config",
      # At this time Wxmac is installed Unicode only
      "UNICODE=1",
      # And thus we have no need for multiversion support
      "INSTALL_MULTIVERSION=0",
      # OpenGL and stuff
      "BUILD_GLCANVAS=1",
      "BUILD_GIZMOS=1",
      "BUILD_STC=1"
    ]
    cd "wxPython" do
      if ARGV.build_devel?
        ENV.append_to_cflags '-arch x86_64' if MacOS.prefer_64_bit?

        system "python", "setup.py",
                         "build_ext",
                         "WXPORT=osx_cocoa",
                         *opts
        system "python", "setup.py",
                         "install",
                         "--prefix=#{prefix}",
                         "WXPORT=osx_cocoa",
                         *opts
      else # for wx 2.8 force 32-bit install with the 10.6 sdk:
        ENV.append_to_cflags '-arch i386'

        system "arch",   "-i386",
                         "python",
                         "setup.py",
                         "build_ext",
                         *opts

        system "arch",   "-i386",
                         "python",
                         "setup.py",
                         "install",
                         "--prefix=#{prefix}",
                         *opts
      end
    end
  end

  def install
    test_python_arch if ARGV.include? "--python"

    args = [
      "--disable-debug",
      "--prefix=#{prefix}",
      "--enable-unicode",
      "--enable-display",
      "--with-opengl"
    ]

    if ARGV.build_devel?
      args += [
        "--with-osx_cocoa",
        "--with-libjpeg",
        "--with-libtiff",
        "--with-libpng",
        "--with-zlib",
        "--enable-dnd",
        "--enable-clipboard",
        "--enable-webkit",
        "--enable-svg",
        "--with-expat"
      ]
    end

    unless ARGV.build_devel?
      # Force i386 wor wx 2.8
      ENV.m32

      # build will fail on Lion unless we use the 10.6 sdk (note wx 2.9 does fine)
      ENV.append_to_cflags '-isysroot /Developer/SDKs/MacOSX10.6.sdk -mmacosx-version-min=10.6' if MacOS.lion?
    end

    system "./configure", *args
    system "make install"

    unless ARGV.build_devel?
      # erlang needs contrib/stc during configure phase.
      %w{ gizmos stc ogl }.each do |c|
       system "make", "-C", "contrib/src/#{c}", "install"
      end
    end

    if ARGV.include? "--python"
      ENV['WXWIN'] = Dir.getwd
      if ARGV.build_devel?
        # We have already downloaded wxPython in a bundle with wxWidgets
        install_wx_python
      else
        # We need to download wxPython separately (see formula at top)
        Wxpython.new.brew { install_wx_python }
      end
    end
  end

  def caveats
    s = ''
    unless ARGV.build_devel?
      s += <<-EOS.undent
        wxWidgets 2.8.x builds 32-bit only, so you probably won't be able to use it
        for other Homebrew-installed software. You can try to build with --devel to
        get the wxWidgets 2.9.x (unstable) for 64-bit and cocoa support.

      EOS
      if ARGV.include? '--python'
        s += <<-EOS.undent
          You will also need run python in 32-bit mode for wx. If you are on a 64-bit
          platform, you will need to run Python in 32-bit mode:

          arch -i386 python [args]

          Homebrew Python does not support this by default. So, homebrew Python must
          be built with --universal --framework.
          Alternative, you can try brew wxmac --python --devel for wx 2.9 in 64-bit.

        EOS
      end
    else
      s += "wx 2.9.x is the unstable (--devel) release. Some things *may* be broken.\n\n"
    end

    if ARGV.include? '--python'
      s += <<-EOS.undent
        Python bindings require that Python be built as a Framework; this is the
        default for Mac OS provided Python but not (yet) for Homebrew Python.
        Build python with `--framework`.

      EOS
    end

    return s
  end
end
