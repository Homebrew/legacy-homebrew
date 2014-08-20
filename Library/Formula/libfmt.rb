require 'formula'

class Libfmt < Formula
  homepage 'http://swtch.com/plan9port/unix/'
  url 'http://swtch.com/plan9port/unix/libfmt-20110530.tgz'
  sha1 '165a6e8e1c6632647b934a6a4c65151a3ece74b6'

  depends_on 'libutf'

  def install
    # Make.Darwin-386 is the only Makefile they have
    inreplace 'Makefile' do |f|
      f.gsub! 'Make.$(SYSNAME)-$(OBJTYPE)', 'Make.Darwin-386'
    end
    system "make", "PREFIX=#{prefix}", "install"
  end
end
