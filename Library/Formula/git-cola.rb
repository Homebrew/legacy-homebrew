require 'formula'

class GitCola < Formula
  homepage 'http://git-cola.github.io/'
  url 'https://github.com/git-cola/git-cola/archive/v1.9.2.tar.gz'
  sha1 '62becefdfa2b899d123259b9d640ab2090a5062c'

  head 'https://github.com/git-cola/git-cola.git'

  option 'with-docs', "Build man pages using asciidoc and xmlto"

  depends_on :python
  depends_on 'pyqt'

  if build.include? 'with-docs'
    # these are needed to build man pages
    depends_on 'asciidoc'
    depends_on 'xmlto'
  end

  def install
    python do
      # The python do block creates the PYTHONPATH and temp. site-packages
      system "make", "prefix=#{prefix}", "install"

      if build.include? 'with-docs'
        system "make", "-C", "share/doc/git-cola",
                       "-f", "Makefile.asciidoc",
                       "prefix=#{prefix}",
                       "install", "install-html"
      end
    end
  end

end
