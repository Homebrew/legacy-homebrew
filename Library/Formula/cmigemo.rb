require 'formula'

class Cmigemo <Formula
  url 'http://www.kaoriya.net/dist/var/cmigemo-1.3c.tar.bz2'
  homepage 'http://www.kaoriya.net/#CMIGEMO'
  md5 '0b9d2feff4cfdc673cc1947fe54191ed'

  depends_on 'nkf'

  def install
    system "./configure"

    inreplace 'config.mk' do |s|
      s.gsub! 'prefix = /usr/local', "prefix = #{prefix}"
    end

    system "make osx"
    system "make osx-dict"

    Dir.chdir 'dict' do
      system "make utf-8"
    end

    # XXX
    mkdir "#{prefix}/share"
    mkdir "#{prefix}/share/migemo"
    mkdir "#{prefix}/share/migemo/cp932"
    mkdir "#{prefix}/share/migemo/euc-jp"
    mkdir "#{prefix}/share/migemo/utf-8"

    system "make osx-install"
    system "chmod 755 #{prefix}/bin/cmigemo"
    system "install_name_tool -change libmigemo.1.dylib #{prefix}/lib/libmigemo.1.dylib #{prefix}/bin/cmigemo"
  end
end
