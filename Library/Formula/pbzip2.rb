require 'formula'

class Pbzip2 < Formula
  url 'http://compression.ca/pbzip2/pbzip2-1.1.6.tar.gz'
  homepage 'http://compression.ca/pbzip2/'
  md5 '26cc5a0d882198f106e75101ff0544a3'

  fails_with_llvm :build => 2334

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! 'PREFIX', prefix
      s.gsub! "/man/", "/share/man/"

      # Per fink and macport:
      s.gsub! "-pthread -lpthread", ""
    end

    system "make install"
  end
end
