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
    sha256 "b6390fed49e3f8da554814bc1c08d13d0da44d6ef5efa22de30e43e9f7bc023a" => :yosemite
    sha256 "b563163757eb060202d40004e96914ffe5d01070c74f7a47d186e2658e9713da" => :mavericks
    sha256 "73db27fb5b2c795140722b3016384038bfa86cee895afb3c2343111061e104e5" => :mountain_lion
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

    # wxPython is hardcoded to install headers in wx's prefix;
    # set it to use wxPython's prefix instead
    # See #47187.
    inreplace %w[wxPython/config.py wxPython/wx/build/config.py],
      "WXPREFIX +", "'#{prefix.to_s}' +"

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
