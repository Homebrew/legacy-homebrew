require 'formula'

class Spim < Formula
  homepage 'http://spimsimulator.sourceforge.net/'
  url 'http://patrickod.com/code/spim.tar.gz'
  version '8.0'
  md5 'cf3b40b9bc6eea3a7173b7c6bf834ce6'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "BIN_DIR", bin
      s.change_make_var! "EXCEPTION_DIR", libexec
      s.change_make_var! "MAN_DIR", man1
    end

    system "make"
    system "make install"
    system "make install-man"
    system "make test"

    mv "#{man1}/spim.man", "#{man1}/spim.1"
  end
end
