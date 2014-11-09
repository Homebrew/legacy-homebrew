require 'formula'

class Msp430ElfIncludes < Formula
  homepage 'http://www.ti.com/tool/msp430-gcc-opensource'
  url 'http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/MSPGCC/latest/exports/msp430-support-files.zip'
  sha1 '791f99fa2506a7b85572401131ff9416d1acdbc8'

  depends_on 'msp430-elf-gcc'

  def install
    FileUtils.mkdir_p "#{include}/msp430"
    FileUtils.mkdir_p "#{lib}/msp430/ldscripts"
    FileUtils.cp Dir.glob('*.h'), "#{include}/msp430"
    FileUtils.cp Dir.glob('*.ld'), "#{lib}/msp430/ldscripts"
  end
end