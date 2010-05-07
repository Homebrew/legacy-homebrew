require 'formula'

class GitSubtree <Formula
  homepage 'http://github.com/apenwarr/git-subtree'
  head 'git://github.com/apenwarr/git-subtree.git',
        :tag => 'c00d1d11688dc02f066196ed18783effdb7767ab'

  # Not depending on git because people might have it
  # installed through another means

  def install
    bin.install "git-subtree.sh" => "git-subtree"
  end
end
