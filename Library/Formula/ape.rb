require 'formula'

class Ape < Formula
  url 'https://github.com/APE-Project/APE_Server/tarball/v1.1.0'
  homepage 'http://www.ape-project.org/'
  md5 '8e2d75bc558aa908e18c6765fc65eb53'

  def install
    inreplace 'Makefile' do |m|
      m.change_make_var! 'prefix', prefix
    end
    system "./build.sh"
    system "make install"
  end

end
