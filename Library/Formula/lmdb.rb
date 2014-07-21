require 'formula'

class Lmdb < Formula
  homepage 'http://symas.com/mdb/'
  url 'https://gitorious.org/mdb/mdb/archive/LMDB_0.9.11.tar.gz'
  sha1 '8015de70514e8b437b4bc43718a7034101efdc67'

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
