require 'formula'

class Libbio < Formula
  homepage 'http://swtch.com/plan9port/unix/'
  url 'http://swtch.com/plan9port/unix/libbio-20110530.tgz'
  sha1 '9a2471284ea2c5809762c9dd38470273a6240048'

  depends_on 'libutf'
  depends_on 'libfmt'

  def install
    # Make.Darwin-386 is the only Makefile they have
    inreplace 'Makefile' do |f|
      f.gsub! 'Make.$(SYSNAME)-$(OBJTYPE)', 'Make.Darwin-386'
    end
    system "make", "PREFIX=#{prefix}", "install"
  end
end
