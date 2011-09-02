require 'formula'

class Asciidoc < Formula
  url 'http://downloads.sourceforge.net/project/asciidoc/asciidoc/8.6.5/asciidoc-8.6.5.tar.gz'
  md5 '9247724283501ec1cfb27d5eae9e5eaf'
  head 'https://code.google.com/p/asciidoc/', :using => :hg
  homepage 'http://www.methods.co.nz/asciidoc'

  def install
    if ARGV.build_head? and not File.exists? "./configure"
      ohai "Creating configure file"
      system "autoconf"
    end
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
