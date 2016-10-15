require 'formula'

class HgGit < Formula
  homepage 'https://bitbucket.org/durin42/hg-git/overview'
  url 'https://bitbucket.org/durin42/hg-git/get/0.4.0.tar.bz2'
  sha1 'b7dcf179d6c41fe284cb4dd070376de157d82ab9'
  head 'https://bitbucket.org/durin42/hg-git', :using => :hg

  depends_on :python

  def install
    prefix.install 'hggit'
  end

  def caveats; <<-EOS.undent
    To enable hg-git, add the following lines to your ~/.hgrc

       [extensions]
       hggit = #{prefix}/hggit
    EOS
  end
end
