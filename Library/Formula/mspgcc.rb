require 'formula'

class Mspgcc <Formula
  url 'http://downloads.sourceforge.net/project/mspgcc4/mspgcc4/mspgcc4-20100829.tar.bz2'
  # Caution: buildgcc.sh changes with new releases
  # Be sure to run interactively to make sure the install works
  md5 'c372c46857dcac7dc81d32574e1f7db0'
  homepage 'http://mspgcc4.sf.net/'
  head 'git://mspgcc4.git.sourceforge.net/gitroot/mspgcc4/mspgcc4'

  # required by build system
  depends_on 'wget'

  def install
    # We want the option [2] defaults: answer 00002 to everything.
    # 00002 evaluates to "n" for questions
    # 00002 evaluates to a string for everything else
    # This should select: gcc-4.4.3, gdb-7.0.1, ti_* gcc, none for insight
    # Binary stripping will be skipped, but homebrew does this anyway
    # For why these versions are used:
    #   see: http://mspgcc4.sf.net/
    #   see: http://processors.wiki.ti.com/index.php/MSP430_LaunchPad_Mac_OS_X
    system "yes 00002 | sh buildgcc.sh"
    # replace 00002 with the real build location
    system "sed s_00002_#{prefix}_g build/00002 > build/homebrew.sh"
    system "sh build/homebrew.sh"
  end
end
