require 'formula'

class Lmdb < Formula
  homepage 'http://symas.com/mdb/'
  url 'ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.35.tgz'
  sha1 'db02243150b050baac6a8ea4145ad73a1f6d2266'

  head 'git://git.openldap.org/openldap.git', :branch => 'mdb.master'

  def install
    # .so -> .dylib
    inreplace 'libraries/liblmdb/Makefile', ".so", ".dylib"

    # fix non-POSIX `cp` multiple source files
    inreplace 'libraries/liblmdb/Makefile' do |s|
      s.gsub! 'cp $(IPROGS) $(DESTDIR)$(prefix)/bin',
              'for f in $(IPROGS); do cp $$f $(DESTDIR)$(prefix)/bin/; done'
      s.gsub! 'cp $(ILIBS) $(DESTDIR)$(prefix)/lib',
              'for f in $(ILIBS); do cp $$f $(DESTDIR)$(prefix)/lib/; done'
      s.gsub! 'cp $(IHDRS) $(DESTDIR)$(prefix)/include',
              'for f in $(IHDRS); do cp $$f $(DESTDIR)$(prefix)/include/; done'
      # also fix the /share/man/man path as well
      s.gsub! 'cp $(IDOCS) $(DESTDIR)$(prefix)/man/man1',
              'for f in $(IDOCS); do cp $$f $(DESTDIR)$(prefix)/share/man/; done'
    end

    man.mkpath
    bin.mkpath
    lib.mkpath
    include.mkpath

    cd 'libraries/liblmdb' do
      system "make", "install", "prefix=#{prefix}"
    end
  end
end
