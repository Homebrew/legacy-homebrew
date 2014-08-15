require 'formula'

class Lmdb < Formula
  homepage 'http://symas.com/mdb/'
  url 'https://gitorious.org/mdb/mdb/archive/LMDB_0.9.13.tar.gz'
  sha1 '8843f07c997841b56ba121d4d3bfb343803c42aa'

  head 'git://git.openldap.org/openldap.git', :branch => 'mdb.master'

  def install
    inreplace "libraries/liblmdb/Makefile" do |s|
      s.gsub! ".so", ".dylib"
      s.gsub! "$(DESTDIR)$(prefix)/man/man1", "$(DESTDIR)$(prefix)/share/man/man1"
    end

    man1.mkpath
    bin.mkpath
    lib.mkpath
    include.mkpath

    system "make", "-C", "libraries/liblmdb", "install", "prefix=#{prefix}"
  end
end
