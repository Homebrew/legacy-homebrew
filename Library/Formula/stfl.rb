require 'formula'

class Stfl <Formula
  url 'http://www.clifford.at/stfl/stfl-0.21.tar.gz'
  homepage 'http://www.clifford.at/stfl/'
  md5 '888502c3f332a0ee66e490690d79d404'

  depends_on 'ncursesw'
  depends_on 'libiconv'

  def install
    inreplace 'Makefile' do |s|
      s.sub! /(LDLIBS \+=) (.*)$/, '\1 $(LDFLAGS) \2 -liconv'
      s.gsub! /libstfl\.so\.\$\(VERSION\)/, 'libstfl.$(VERSION).dylib'
      s.sub! /-Wl,-soname,\$\(SONAME\) -o \$@ \$\^/, '-o $@ $^ $(LDLIBS)'
      s.gsub! /libstfl\.so/, 'libstfl.dylib'
    end
    system "make FOUND_SWIG=0"
    system "make FOUND_SWIG=0 install prefix=#{prefix}"
  end
end
