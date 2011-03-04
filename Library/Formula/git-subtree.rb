require 'formula'

class GitSubtree <Formula
  homepage 'https://github.com/apenwarr/git-subtree'
  url 'https://github.com/apenwarr/git-subtree/zipball/v0.4'
  version '0.4'
  md5 '904f325d2208ad5ca542e7bb56c50f9c'

  head 'git://github.com/apenwarr/git-subtree.git'

  def options
    [['--build-docs', "Build man pages using asciidoc and xmlto"]]
  end

  if ARGV.include? '--build-docs'
    # these are needed to build man pages
    depends_on 'asciidoc'
    depends_on 'xmlto'
  end

  def install
    if ARGV.include? '--build-docs'
      system "make doc"
      man1.install "git-subtree.1"
    else
      doc.install "git-subtree.txt"
    end
    bin.install "git-subtree.sh" => "git-subtree"
  end
end
