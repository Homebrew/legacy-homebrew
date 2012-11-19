require 'formula'

class GitSubtree < Formula
  head 'https://github.com/rentzsch/git-subtree.git'
  homepage 'https://github.com/rentzsch/git-subtree'

  option 'with-docs', "Build man pages using asciidoc and xmlto"
  
  if build.include? 'with-docs'
    depends_on 'asciidoc'
    depends_on 'xmlto'
  end

  def install
    bin.install Dir['git-subtree', 'git-subtree.sh']

    if build.include? 'with-docs'
      system "make doc"
      man1.install Dir['git-subtree.1']
    end
  end
end
