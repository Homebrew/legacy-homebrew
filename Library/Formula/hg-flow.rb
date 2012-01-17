require 'formula'

class HgFlow < Formula
  url 'https://bitbucket.org/yinwm/hgflow/get/develop.tar.gz'
  version 'v0.4'
  homepage 'https://bitbucket.org/yinwm/hgflow/wiki/Home'
  md5 '4c818c98c81cb01e6a1b5a38138c1a84'

  depends_on 'mercurial'

  def install
    prefix.install Dir['*']
    system <<-HEREDOC.undent
      echo "
      [extensions]
      hgflow = /usr/local/Cellar/hg-flow/v0.4/src/hgflow/hgflow.py" >> ~/.hgrc
      HEREDOC
  end

  def caveats; <<-EOS.undent
    Check your ~/.hgrc for [extionsions]
    EOS
  end
end
