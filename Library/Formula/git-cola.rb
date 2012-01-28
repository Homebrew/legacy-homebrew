require 'formula'

class GitCola < Formula
  url 'https://github.com/downloads/git-cola/git-cola/git-cola-1.7.4.1.tar.gz'
  homepage 'http://git-cola.github.com/'
  md5 'd0f667c91e12a707df73060bf0822c27'

  head 'https://github.com/git-cola/git-cola.git'

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
