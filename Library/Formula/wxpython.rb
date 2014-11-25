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
  revision 1

  bottle do
    sha1 "d9fe82c3cc35a8b2a8a66ca66ed8024641884561" => :yosemite
    sha1 "8fa3a83c48852dc978ee408f5f454ee9e4e46056" => :mavericks
    sha1 "8e753e7542cf4dd38b7c758fe12902bd2134bf93" => :mountain_lion
  end

  if MacOS.version <= :snow_leopard
    depends_on :python
    depends_on FrameworkPython
  end
  depends_on "wxmac"

  stable do
    # See closed ticket #16590:
    #     Update wxpython lib/plot.py (numpy has removed oldnumeric)
    #     http://trac.wxwidgets.org/ticket/16590
    # Applied upstream: http://trac.wxwidgets.org/changeset/77995
    # This duplicate gist patch just strips "/trunk" from within target file's path
    patch :p0 do
      url "https://gist.githubusercontent.com/dakcarto/f0331c2e4e97a7c4271e/raw/9e65152464c6321bd2c5ff723c21b6cc78958e03/wxpython_77995.diff"
      sha1 "73b90a983fbb5330abc1b3866817081c8efde479"
    end
  end

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
