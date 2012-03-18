require 'formula'

class GitCola < Formula
  head 'https://github.com/git-cola/git-cola.git'
  url 'https://github.com/git-cola/git-cola.git', :tag => 'v1.7.6'
  version '1.7.6'
  homepage 'http://git-cola.github.com/'

  depends_on 'pyqt'

  def options
    [['--build-docs', "Build man pages using asciidoc and xmlto"]]
  end

  if ARGV.include? '--build-docs'
    # these are needed to build man pages
    depends_on 'asciidoc'
    depends_on 'xmlto'
  end

  def install
    ENV.prepend 'PYTHONPATH', "#{HOMEBREW_PREFIX}/lib/python", ':'
    system "make", "prefix=#{prefix}", "install"

    if ARGV.include? '--build-docs'
      system "make",
             "-C", "share/doc/git-cola",
             "-f", "Makefile.asciidoc",
             "prefix=#{prefix}",
             "install", "install-html"
    end
  end
end
