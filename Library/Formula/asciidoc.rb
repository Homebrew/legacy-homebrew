require 'formula'

class Asciidoc < Formula
  url 'http://downloads.sourceforge.net/project/asciidoc/asciidoc/8.6.6/asciidoc-8.6.6.tar.gz'
  md5 '44b872d9c300ffa5a8fe8b3c4d10957c'
  head 'https://code.google.com/p/asciidoc/', :using => :hg
  homepage 'http://www.methods.co.nz/asciidoc'

  def install
    if ARGV.build_head? and not File.exists? "./configure"
      ohai "Creating configure file"
      system "autoconf"
    end
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
