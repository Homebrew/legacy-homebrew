require 'formula'

class Libregexp9 < Formula
  homepage 'http://swtch.com/plan9port/unix/'
  url 'http://swtch.com/plan9port/unix/libregexp9-20110530.tgz'
  sha1 'fab54e50693d2594f0b5f05040343c9accde618f'

  depends_on 'libutf'
  depends_on 'libfmt'

  def install
    # Make.Darwin-386 is the only Makefile they have
    inreplace 'Makefile' do |f|
      f.gsub! 'man/man7', 'share/man/man7'
      f.gsub! 'Make.$(SYSNAME)-$(OBJTYPE)', 'Make.Darwin-386'
    end
    system "make", "PREFIX=#{prefix}", "install"
  end
end
