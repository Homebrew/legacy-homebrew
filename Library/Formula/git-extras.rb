require 'formula'

class GitExtras < Formula
  homepage 'https://github.com/visionmedia/git-extras'
  url 'https://github.com/visionmedia/git-extras/tarball/1.5.0'
  sha1 '60e0ad00b046d76b3c111d9cc3d02aa4191e450a'

  head 'https://github.com/visionmedia/git-extras.git', :branch => 'master'

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
