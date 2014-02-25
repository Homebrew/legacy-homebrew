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

class Wxpython < Formula
  homepage 'http://www.wxwidgets.org'
  url 'http://downloads.sourceforge.net/project/wxpython/wxPython/3.0.0.0/wxPython-src-3.0.0.0.tar.bz2'
  sha1 '48451763275cfe4e5bbec49ccd75bc9652cba719'

  depends_on :python
  depends_on FrameworkPython
  depends_on 'wxmac'

  def install
    ENV['WXWIN'] = buildpath

    args = [
      # Reference our wx-config
      "WX_CONFIG=#{Formula.factory('wxmac').opt_prefix}/bin/wx-config",
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

  test do
    system "python", "-c", "import wx"
  end
end