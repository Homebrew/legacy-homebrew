require "formula"

class Onetime < Formula
  homepage "http://red-bean.com/onetime/"
  url "http://red-bean.com/onetime/onetime-1.81.tar.gz"
  sha1 "db8f84963ed7b5831fdf4c19b4494cf7bfd5b753"

  devel do
    url "https://github.com/kfogel/OneTime/archive/2.0-beta2.tar.gz"
    version "2.0.02"
    sha1 "5ae36caf5259b35f2a651b1ab0b162d834a8d339"
  end

# inreplace required for now due to upstream issue, reported here: https://github.com/kfogel/OneTime/issues/11

  def install
    inreplace "Makefile", "$(DESTDIR)/usr/bin/", "$(DESTDIR)#{bin}"
    mkdir bin
    system "make", "install"
  end

  test do
    system "#{bin}/onetime", "--version"
  end
end
