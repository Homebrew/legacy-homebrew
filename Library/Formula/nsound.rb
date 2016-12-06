require 'formula'


class Nsound < Formula
  homepage 'http://nsound.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/nsound/nsound/nsound-0.8.1/nsound-0.8.1.tar.gz'
  md5 'f12384b0bde5200153a47554a60caa01'

  depends_on 'scons' => :build
  depends_on 'swig' => :build
  depends_on 'libao' => :optional        # or 'portaudio' (either one provides audio playback capabilities, but libao seems to be preferred)

  def patches
    { :p2 => [
      "http://nsound.svn.sourceforge.net/viewvc/nsound/branch/nsound-dev1/SConstruct?view=patch&r1=691&r2=705&pathrev=705",     # empty CPPPATH
      "http://nsound.svn.sourceforge.net/viewvc/nsound/branch/nsound-dev1/NsoundConfig_Mac.py?r1=684&r2=705&view=patch"]        # Mac build fixes
    }
  end

  def install
    # build C++ lib
    system "scons"

    # generate Nsound.h
    system "scons", "disable-python=1" "src/Nsound/Nsound.h"
    # generate setup.py (uses swig)
    system "scons", "setup.py"
    # build Python module
    system "python", "setup.py", "build"

    # install C++ library and tools
    system "scons", "install"
    lib.install Dir["lib/*"]
    bin.install Dir["bin/*"]
    # install Python module
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  def test
    system "python", "-c", "'from Nsound import *; b=Buffer(); assert str(b) == \"Nsound.Buffer holding 0 samples\"'"
  end
end
