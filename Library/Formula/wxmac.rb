require 'formula'

def devel?; ARGV.flag? '--devel'; end
def build_python?; ARGV.include? "--python"; end

def which_python
  if ARGV.include? '--system-python'
    '/usr/bin/python'
  else
    'python'
  end
end

class Wxpython < Formula
  if devel?
    url 'http://downloads.sourceforge.net/project/wxpython/wxPython/2.9.2.4/wxPython-src-2.9.2.4.tar.bz2'
    md5 '8dae829b3bb3ccfe279d5d3948562c5f'
  else
    url 'http://downloads.sourceforge.net/wxpython/wxPython-src-2.8.11.0.tar.bz2'
    md5 '63f73aae49e530852db56a31b57529fa'
  end
end

class Wxmac < Formula
  
  if devel?
    url 'http://downloads.sourceforge.net/project/wxwindows/2.9.2/wxWidgets-2.9.2.tar.bz2'
    md5 'd6cec5bd331ba90b74c1e2fcb0563620'
  else    
    url 'http://downloads.sourceforge.net/project/wxwindows/2.8.11/wxMac-2.8.11.tar.bz2'
    md5 '8d84bfdc43838e2d2f75031f62d1864f'
  end
  
  homepage 'http://www.wxwidgets.org'

  def options
    [
      ['--devel',  'Use 2.9.x branch'],
      ['--python', 'Build Python bindings'],
      ['--system-python', 'Build against the OS X Python instead of whatever is in the path.']
    ]
  end

  def test_python_arch
    system "arch -i386 #{which_python} --version"
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

  def install_wx_python
    opts = [
      # Reference our wx-config
      "WX_CONFIG=#{bin}/wx-config",
      # At this time Wxmac is installed ANSI only
      "UNICODE=0",
      # And thus we have no need for multiversion support
      "INSTALL_MULTIVERSION=0",
      # TODO: see if --with-opengl can work on the wxmac build
      "BUILD_GLCANVAS=0",
      # Contribs that I'm not sure anyone cares about, but
      # wxPython tries to build them by default
      "BUILD_STC=0",
      "BUILD_GIZMOS=0"
    ]
    Dir.chdir "wxPython" do
      system "arch", "-i386",
                     which_python,
                     "setup.py",
                     "build_ext",
                     *opts

      system "arch", "-i386",
                     which_python,
                     "setup.py",
                     "install",
                     "--prefix=#{prefix}",
                     *opts
    end
  end

  def install
    test_python_arch if build_python?

    unless devel?
      # Force i386
      %w{ CFLAGS CXXFLAGS LDFLAGS OBJCFLAGS OBJCXXFLAGS }.each do |compiler_flag|
        ENV.remove compiler_flag, "-arch x86_64"
        ENV.append compiler_flag, "-arch i386"
      end
    end

    if devel?
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-osx-cocoa",
                            "--enable-unicode",
                            "--with-macosx-sdk=/Developer/SDKs/MacOSX10.6.sdk"
    else 
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--enable-unicode",
                            "--with-macosx-sdk=/Developer/SDKs/MacOSX10.6.sdk",
                            "--with-macosx-version-min=10.6"
    end  
    
    system "make install"

    if build_python?
      ENV['WXWIN'] = Dir.getwd
      Wxpython.new.brew { install_wx_python }
    end
  end

  def caveats
    s = <<-EOS.undent
      wxWidgets 2.8.x builds 32-bit only, so you probably won''t be able to use it
      for other Homebrew-installed softare on Snow Leopard (like Erlang).

    EOS

    if build_python?
      s += <<-EOS.undent
        Python bindings require that Python be built as a Framework; this is the
        default for Mac OS provided Python but not for Homebrew python (compile
        using the --framework option).

        You will also need 32-bit support for Python. If you are on a 64-bit
        platform, you will need to run Python in 32-bit mode:

          arch -i386 python [args]

        Homebrew Python does not support this by default (compile using the
        --universal option)

      EOS
    end

    return s
  end
end
