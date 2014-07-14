require 'formula'

class GitExtras < Formula
  homepage 'https://github.com/visionmedia/git-extras'
  url 'https://github.com/visionmedia/git-extras/archive/1.9.1.tar.gz'
  sha1 '145124710f2f06f17984e335c8b840c90c43eb44'

  head 'https://github.com/visionmedia/git-extras.git', :branch => 'master'

  bottle do
    cellar :any
    sha1 "46a9571d689cd5af02f176134dc2423c972c86a0" => :mavericks
    sha1 "8d9f5cf5005386e63c940da86034956400a87c58" => :mountain_lion
    sha1 "8e00abe2ca5e62271a38e0063b3e01de16a420a7" => :lion
  end

  # Don't take +x off these files
  skip_clean 'bin'

  def install
    inreplace 'Makefile', %r|\$\(DESTDIR\)(?=/etc/bash_completion\.d)|, '$(DESTDIR)$(PREFIX)'
    system "make", "PREFIX=#{prefix}", "install"
  end
end
