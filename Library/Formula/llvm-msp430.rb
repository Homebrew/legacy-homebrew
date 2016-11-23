require 'formula'

class LlvmMsp430 <Formula
  homepage 'https://www.fooe.net/trac/llvm-msp430/wiki'
  head 'https://www.fooe.net/svn/llvm-msp430/trunk'
  # Tarballs are not offered as of this writing.

  keg_only <<-KEG.undent
    This brew builds its own 'clang' and 'llvm',
    which conflict with XCode and the llvm formula.
  KEG

  def download_strategy
    SubversionDownloadStrategy
  end

  def install
    system "make all"
    prefix.install Dir['build/*']
  end

  def caveats
    <<-EOS.undent
      Since this package is keg-only, you must run build commands using something like:

        PATH=#{bin}:$PATH make

      You may use:

        PATH=`brew --prefix llvm-msp430`/bin

      to get the appropiate PATH that will continue to work if versions change.

      The following websites may be helpful for building your project:

        http://processors.wiki.ti.com/index.php/MSP430_LaunchPad_Mac_OS_X
        https://www.fooe.net/trac/llvm-msp430
    EOS
  end
end
