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
    ohai "The source tree is about 1 GB, but will be removed after the build is complete."
    SubversionDownloadStrategy
  end

  def install
    system "make all"
    prefix.install Dir['build/*']
  end

  def caveats
    <<-EOS.undent
      To build your MSP430 project, use commands like this:

        #{prefix}/bin/clang -ccc-host-triple msp430-elf -c foo.c
        #{prefix}/bin/clang -ccc-host-triple msp430-elf -L#{prefix}/msp430/lib -L#{prefix}/lib/msp430 -o foo.msp foo.o

      For more details, visit https://www.fooe.net/trac/llvm-msp430
    EOS
  end
end
