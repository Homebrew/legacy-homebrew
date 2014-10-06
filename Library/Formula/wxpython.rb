require "formula"

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
  url "https://downloads.sourceforge.net/project/wxpython/wxPython/3.0.1.1/wxPython-src-3.0.1.1.tar.bz2"
  sha1 "d2c4719015d7c499a9765b1e5107fdf37a32abfb"

  bottle do
    sha1 "e7fad91e96497ecae7a12f55f092c74e07e41f5b" => :mavericks
    sha1 "3cbb8428f88ac9363081cb79f18067895fdf35cf" => :mountain_lion
    sha1 "e6db873562487f0135412f5fff9a367d0a29552b" => :lion
  end

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
