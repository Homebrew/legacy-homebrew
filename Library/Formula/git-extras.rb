require 'formula'

class GitExtras < Formula
  homepage 'https://github.com/visionmedia/git-extras'
  url 'https://github.com/visionmedia/git-extras/archive/1.8.0.tar.gz'
  sha1 '5a52d3e247a5134c8e2bf89b339a204a7f4ad8e0'

  head 'https://github.com/visionmedia/git-extras.git', :branch => 'master'

  # Don't take +x off these files
  skip_clean 'bin'

  def install
    inreplace 'Makefile', %r|\$\(DESTDIR\)(?=/etc/bash_completion\.d)|, '$(DESTDIR)$(PREFIX)'
    system "make", "PREFIX=#{prefix}", "install"
  end
end
