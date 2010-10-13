require 'formula'

class Pbzip2 <Formula
  url 'http://compression.ca/pbzip2/pbzip2-1.1.1.tar.gz'
  homepage 'http://compression.ca/pbzip2/'
  md5 'b354422759da7113da366aad1876ed5d'

  def install
    fails_with_llvm

    inreplace "Makefile" do |s|
      s.change_make_var! 'PREFIX', prefix
      s.gsub! "/man/", "/share/man/"

      # Per fink and macport:
      s.gsub! "-pthread -lpthread", ""
    end

    system "make install"
  end
end
