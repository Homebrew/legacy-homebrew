require 'formula'

class Unqlite < Formula
  homepage 'http://www.unqlite.org'
  url 'http://unqlite.org/db/unqlite-db-116.zip'
  sha1 'a9df6a958d1c2fad2103e1d57dccf0a3f4c85b25'
  version '1.1.6'

  def install
    system "#{ENV.cc} -Wall -fPIC -c *.c"
    system "#{ENV.cc} -dynamiclib -install_name -Wl -o libunqlite.1.dylib *.o"
    include.install Dir['*.h']
    lib.install Dir['*.dylib']
    lib.install_symlink lib/'libunqlite.1.dylib' => 'libunqlite.dylib'
  end

end
