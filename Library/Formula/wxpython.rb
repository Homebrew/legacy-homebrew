class FrameworkPythonRequirement < Requirement
  fatal true

  satisfy do
    q = `python -c "import distutils.sysconfig as c; print(c.get_config_var('PYTHONFRAMEWORK'))"`
    !q.chomp.empty?
  end

  def message
    "Python needs to be built as a framework."
  end
end

class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxwidgets.org/"
  url "https://downloads.sourceforge.net/project/wxpython/wxPython/3.0.2.0/wxPython-src-3.0.2.0.tar.bz2"
  sha256 "d54129e5fbea4fb8091c87b2980760b72c22a386cb3b9dd2eebc928ef5e8df61"

  bottle do
    sha1 "e73ade83e5802db3b824ebdc8b8fc62d0c70ae6f" => :yosemite
    sha1 "739ab76d3bc7e0f804ea487d14274630ae0e19cc" => :mavericks
    sha1 "76bd0e1a6ce0fba459b4847836c3dfd0ac4a31af" => :mountain_lion
  end

  if MacOS.version <= :snow_leopard
    depends_on :python
    depends_on FrameworkPythonRequirement
  end
  depends_on "wxmac"

  option :universal

  def install
    ENV["WXWIN"] = buildpath

    if build.universal?
      ENV.universal_binary
    else
      ENV.append_to_cflags "-arch #{MacOS.preferred_arch}"
    end

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
      system "python", "setup.py", "install", "--prefix=#{prefix}", *args
    end
  end
end
