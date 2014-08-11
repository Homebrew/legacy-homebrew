require 'formula'

class Lmdb < Formula
  homepage 'http://symas.com/mdb/'
  url 'https://gitorious.org/mdb/mdb/archive/LMDB_0.9.13.tar.gz'
  sha1 '3b509d2044b102442f41d957d7c2ed30d600da23'

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
