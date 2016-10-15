require 'formula'

class GitIgnore < Formula
  homepage 'https://github.com/imwithye/git-ignore'

  # Use the tag instead of the tarball to get submodules
  url 'https://github.com/imwithye/git-ignore.git', :tag => 'v0.2'

  def install
    prefix.install "LICENSE", "README.md"
    prefix.install "git-ignore" => "include"
    bin.install_symlink "#{include}/git_ignore.py" => "git-ignore"
  end
  
  test do
    system "#{bin}/git-ignore"
  end
end