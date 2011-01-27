require 'formula'

class GitSubtree <Formula
  homepage 'http://github.com/apenwarr/git-subtree'
  head 'git://github.com/apenwarr/git-subtree.git',
        :tag => 'v0.3'

  def options
    [
      ['--build-docs', "Build man pages using asciidoc and xmlto"]
    ]
  end

  if ARGV.include? '--build-docs'
    # these are needed to build man pages
    depends_on 'asciidoc'
    depends_on 'xmlto'
  end

  # Not depending on git because people might have it
  # installed through another means

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
