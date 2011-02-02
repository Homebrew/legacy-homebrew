require 'formula'

class Htmltidy <Formula
	url 'http://downloads.sourceforge.net/project/tidy/tidy/04aug00/tidy4aug00.tgz'
 	#head 'cvs://:pserver:anonymous@tidy.cvs.sourceforge.net:/cvsroot/tidy:tidy'
  homepage 'http://tidy.sourceforge.net/'
  md5 '5faa2b127ae7f1c7ab07ed677db189e7'
	version '20000804'

  def install
		inreplace 'Makefile' do |s|
			s.change_make_var! "INSTALLDIR", "#{prefix}/"
			s.sub! /\$\(INSTALLDIR\)man/, '$(INSTALLDIR)share/man'
			s.sub! /chmod 755 tidy; \\.+chgrp bin tidy; \\.+chown bin tidy;/m, 'chmod 755 tidy'
		end

    system "make"

		share.mkdir
		Dir.mkdir "#{prefix}/share/man"
		Dir.mkdir "#{prefix}/share/man/man1"
		bin.mkdir
    system "make install"
  end
end
