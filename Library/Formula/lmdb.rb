require 'formula'

class Lmdb < Formula
  homepage 'http://symas.com/mdb/'
  
  url 'git://git.openldap.org/openldap.git',
    :branch => 'mdb.master',
    :tag => 'OPENLDAP_REL_ENG_2_4_35'
  
  version '2.4.35'
  
  def install
    # .so -> .dylib
    inreplace 'libraries/liblmdb/Makefile', ".so", ".dylib"
    
    # fix non-POSIX `cp` multiple source files
    inreplace 'libraries/liblmdb/Makefile',
      'cp $(IPROGS) $(DESTDIR)$(prefix)/bin',
      'for f in $(IPROGS); do cp $$f $(DESTDIR)$(prefix)/bin/; done'
      
    inreplace 'libraries/liblmdb/Makefile',
      'cp $(ILIBS) $(DESTDIR)$(prefix)/lib',
      'for f in $(ILIBS); do cp $$f $(DESTDIR)$(prefix)/lib/; done'
    
    inreplace 'libraries/liblmdb/Makefile',
      'cp $(IHDRS) $(DESTDIR)$(prefix)/include',
      'for f in $(IHDRS); do cp $$f $(DESTDIR)$(prefix)/include/; done'
    
    # also fix the /share/man/man path as well
    inreplace 'libraries/liblmdb/Makefile',
      'cp $(IDOCS) $(DESTDIR)$(prefix)/man/man1',
      'for f in $(IDOCS); do cp $$f $(DESTDIR)$(prefix)/share/man/; done'
    
    man.mkpath
    bin.mkpath
    lib.mkpath
    include.mkpath
    
    system "cd libraries/liblmdb && make install prefix=#{prefix}"
  end
end