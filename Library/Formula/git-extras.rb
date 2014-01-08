require 'formula'

class GitExtras < Formula
  homepage 'https://github.com/visionmedia/git-extras'
  url 'https://github.com/visionmedia/git-extras/archive/1.9.0.tar.gz'
  sha1 'c4ebdeceaf4cdfde424beef4edca51aa050297f9'

  head 'https://github.com/visionmedia/git-extras.git', :branch => 'master'

  # Don't take +x off these files
  skip_clean 'bin'

  def install
    inreplace 'Makefile', %r|\$\(DESTDIR\)(?=/etc/bash_completion\.d)|, '$(DESTDIR)$(PREFIX)'
    system "make", "PREFIX=#{prefix}", "install"
  end
end
