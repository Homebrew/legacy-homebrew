require 'formula'

class Openconnect < Formula
  url 'ftp://ftp.infradead.org/pub/openconnect/openconnect-2.26.tar.gz'
  homepage 'http://www.infradead.org/openconnect.html'
  md5 'e3c7605fed128efe39c2eb9400af6765'

  def install
    inreplace 'Makefile' do |s|
      s.gsub! '$(DESTDIR)/usr/bin', "$(DESTDIR)#{bin}"
      s.gsub! '$(DESTDIR)/usr/libexec', "$(DESTDIR)#{libexec}"
    end
    system "make install"
  end
end
