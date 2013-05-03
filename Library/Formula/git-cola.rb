require 'formula'

class GitCola < Formula
  homepage 'http://git-cola.github.io/'
  url 'https://github.com/git-cola/git-cola/archive/v1.8.2.tar.gz'
  sha1 '92c09bcf3abcac68f6dc0817e9c8d002260572ae'

  head 'https://github.com/git-cola/git-cola.git'

  option 'with-docs', "Build man pages using asciidoc and xmlto"

  depends_on 'pyqt'

  if build.include? 'with-docs'
    # these are needed to build man pages
    depends_on 'asciidoc'
    depends_on 'xmlto'
  end

  def install
    ENV.prepend 'PYTHONPATH', "#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages", ':'
    system "make", "prefix=#{prefix}", "install"

    if build.include? 'with-docs'
      system "make", "-C", "share/doc/git-cola",
                     "-f", "Makefile.asciidoc",
                     "prefix=#{prefix}",
                     "install", "install-html"
    end
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
