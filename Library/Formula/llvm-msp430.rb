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
    man.mkpath
    Dir.chdir 'build' do
      man.install Dir['man/*']
      man.install Dir['share/man/*']
      prefix.install %w['include', 'lib'] # lib from libcompiler_rt
      lib.install Dir['msp430/lib/*'] # lib from mspgcc's libc
      bin.install Dir['bin/*'] 
    end
  end

  def caveats
    <<-EOS.undent
      MSPGCC's libc and compiler-rt's libcompiler_rt.[Generic/Optimized].a were both installed into #{prefix}/lib/msp430.

      To build your MSP430 project, use commands like this:

        #{prefix}/bin/clang -ccc-host-triple msp430-elf -c foo.c
        #{prefix}/bin/clang -ccc-host-triple msp430-elf -L#{prefix}/lib/msp430 -o foo.msp foo.o

      For more details, visit https://www.fooe.net/trac/llvm-msp430
    EOS
  end
end
