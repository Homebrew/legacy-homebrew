require 'formula'

class WlaDx < Formula
  head 'https://wladx.svn.sourceforge.net/svnroot/wladx', :using => :svn
  homepage 'http://www.villehelin.com/wla.html'
  version '9.5a'

  def install
    ENV.remove_from_cflags '-O3 -march=core2 -msse4.1 -w -pipe'
    ENV.append_to_cflags '-c -O3 -ansi -pedantic -Wall'
    system "chmod +x unix.sh"
    system "chmod +x opcode_table_generator/create_tables.sh"
    system "./unix.sh", "#{Hardware.processor_count}"
    bin.install Dir['./binaries/*']
  end
end
