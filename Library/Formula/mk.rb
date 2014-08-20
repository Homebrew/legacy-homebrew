require 'formula'

class Mk < Formula
  homepage 'http://swtch.com/plan9port/unix/'
  url 'http://swtch.com/plan9port/unix/mk-20110530.tgz'
  sha1 '0a8d343cdbc1158fa879cd855d561bc63412d493'

  depends_on 'libutf'
  depends_on 'libfmt'
  depends_on 'libbio'
  depends_on 'libregexp9'

  def install
    # Make.Darwin-386 is the only Makefile they have
    inreplace 'Makefile' do |f|
      f.gsub! 'man/man1', 'share/man/man1'
      f.gsub! 'Make.$(SYSNAME)-$(OBJTYPE)', 'Make.Darwin-386'
    end
    system "make", "PREFIX=#{prefix}", "install"
  end
end
