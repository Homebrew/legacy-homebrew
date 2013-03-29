require 'formula'

class GitExtras < Formula
  homepage 'https://github.com/visionmedia/git-extras'
  url 'https://github.com/visionmedia/git-extras/archive/1.7.0.tar.gz'
  sha1 'c314b947f285d92c2a227c7d73f46bca258e5111'

  head 'https://github.com/visionmedia/git-extras.git', :branch => 'master'

  # Don't take +x off these files
  skip_clean 'bin'

  def install
    inreplace 'Makefile', %r|\$\(DESTDIR\)(?=/etc/bash_completion\.d)|, '$(DESTDIR)$(PREFIX)'
    system "make", "PREFIX=#{prefix}", "install"
  end
end
