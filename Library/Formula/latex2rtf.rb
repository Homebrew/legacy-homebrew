require 'formula'

class Latex2rtf < Formula
  url 'http://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.0.0/latex2rtf-2.0.0.tar.gz'
  homepage 'http://latex2rtf.sourceforge.net/'
  md5 '39611b6dbb5ce78b48c7695f3fcafb88'

  def install
    inreplace "Makefile" do |s|
      s.remove_make_var! 'PREFIX?'
      s.change_make_var! 'MAN_INSTALL', man1
    end

    system "make PREFIX=#{prefix} install"
  end
end
