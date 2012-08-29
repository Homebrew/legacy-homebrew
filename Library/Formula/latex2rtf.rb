require 'formula'

class Latex2rtf < Formula
  url 'http://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.1.0/latex2rtf-2.1.0.tar.gz'
  homepage 'http://latex2rtf.sourceforge.net/'
  md5 'e89b78f9cfe6d83c79e657a9390e8bc9'

  def install
    inreplace "Makefile" do |s|
      s.remove_make_var! 'PREFIX?'
      s.change_make_var! 'MAN_INSTALL', man1
    end

    system "make", "PREFIX=#{prefix}", "install"
  end
end
