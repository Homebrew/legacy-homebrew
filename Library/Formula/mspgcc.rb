require 'formula'

class Mspgcc <Formula
  url 'http://downloads.sourceforge.net/project/mspgcc4/mspgcc4/mspgcc4-20100815.tar.bz2'
  md5 'f0b1294939963d0f3a431114aac01950'
  homepage 'http://mspgcc4.sf.net/'
  head 'git://mspgcc4.git.sourceforge.net/gitroot/mspgcc4/mspgcc4'

  # required by build system
  depends_on 'wget'

  def install
    # We want the defaults: answer yes to everything.
    # 00001 evaluates to "y" for questions
    # 00001 evaluates to a string for everything else
    system "yes 00001 | sh buildgcc.sh"
    # replace 00001 with the real build location
    # delete the last line, which doesn't work on Mac
    # see: http://processors.wiki.ti.com/index.php/MSP430_LaunchPad_Mac_OS_X
    system "sed -e '$ d' -e s_00001_#{prefix}_g build/00001 > build/homebrew.sh"
    system "sh build/homebrew.sh"
  end
end
