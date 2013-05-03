require 'formula'

class Latex2rtf < Formula
  homepage 'http://latex2rtf.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.1.0/latex2rtf-2.1.0.tar.gz'
  sha1 '31e6280312b56c2c38cf6a3fddff21a9910c7d6f'

  def install
    inreplace "Makefile" do |s|
      s.remove_make_var! 'PREFIX?'
      s.change_make_var! 'MAN_INSTALL', man1
    end

    system "make", "PREFIX=#{prefix}", "install"
  end
end
