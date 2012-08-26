require 'formula'

class GitCola < Formula
  homepage 'http://git-cola.github.com/'
  url 'https://github.com/git-cola/git-cola/tarball/v1.8.0'
  md5 'bbf727c0853ec4140684c2ddb5fd9cf2'
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
    ENV.prepend 'PYTHONPATH', "#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages", ':'
    system "make", "prefix=#{prefix}", "install"

    if ARGV.include? '--build-docs'
      system "make",
             "-C", "share/doc/git-cola",
             "-f", "Makefile.asciidoc",
             "prefix=#{prefix}",
             "install", "install-html"
    end
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
