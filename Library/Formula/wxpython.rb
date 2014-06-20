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
  homepage "http://www.wxwidgets.org"
  url "https://downloads.sourceforge.net/project/wxpython/wxPython/3.0.0.0/wxPython-src-3.0.0.0.tar.bz2"
  sha1 "48451763275cfe4e5bbec49ccd75bc9652cba719"

  if MacOS.version <= :snow_leopard
    depends_on :python
    depends_on FrameworkPython
  end
  depends_on "wxmac"

  def install
    ENV["WXWIN"] = buildpath

    args = [
      "WXPORT=osx_cocoa",
      # Reference our wx-config
      "WX_CONFIG=#{Formula["wxmac"].opt_bin}/wx-config",
      # At this time Wxmac is installed Unicode only
      "UNICODE=1",
      # Some scripts (e.g. matplotlib) expect to `import wxversion`, which is
      # only available on a multiversion build.
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
                     *args

      system "python", "setup.py",
                     "install",
                     "--prefix=#{prefix}",
                     *args
    end
  end
end
