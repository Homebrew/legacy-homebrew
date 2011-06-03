require 'formula'

class Tig < Formula
  url 'https://github.com/jonas/tig/tarball/tig-0.17'
  homepage 'http://jonas.nitro.dk/tig/'
  version '0.17'
  md5 '31a309d64ed80bcc6acf81001f8aa43d'

  head 'https://github.com/jonas/tig.git'

  depends_on 'libiconv'
  depends_on 'autoconf-archive'

  def options
    [['--build-docs', "Build man pages using asciidoc and xmlto"]]
  end

  if ARGV.include? '--build-docs'
    # these are needed to build man pages
    depends_on 'asciidoc'
    depends_on 'xmlto'
  end

  def install
    ENV['ACLOCAL'] = "aclocal -I#{HOMEBREW_PREFIX}/share/aclocal"

    system "make configure"
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    if ARGV.include? '--build-docs'
      system "make install-doc-man"
    end
  end
end
