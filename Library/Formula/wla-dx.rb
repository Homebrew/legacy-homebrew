require 'formula'

class WlaDx < Formula
  homepage 'http://www.villehelin.com/wla.html'
  url 'http://www.villehelin.com/wla_dx_9.5a.tar.gz'
  sha1 '2d14c33b985a594686ca8343488de7c41d690b9d'

  head 'https://wladx.svn.sourceforge.net/svnroot/wladx'

  def install
    %w{CFLAGS CXXFLAGS CPPFLAGS}.each { |e| ENV.delete(e) }
    ENV.append_to_cflags '-c -O3 -ansi -pedantic -Wall'
    system "chmod +x unix.sh"
    system "chmod +x opcode_table_generator/create_tables.sh"
    system "./unix.sh", ENV.make_jobs
    bin.install Dir['./binaries/*']
  end
end
