require 'formula'

class Msp430ElfNewlib < Formula
  homepage 'http://sourceware.org/newlib/'
  url 'ftp://sourceware.org/pub/newlib/newlib-2.1.0.tar.gz'
  sha1 '364d569771866bf55cdbd1f8c4a6fa5c9cf2ef6c'

  def install
    onoe "This version of newlib is meant to be installed during the install of msp430-elf-gcc. Install that package and you'll get this one."
    raise ErrorDurringExecution
  end
end