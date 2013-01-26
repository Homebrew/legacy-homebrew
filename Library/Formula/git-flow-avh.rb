require 'formula'

class GitFlowAvh < Formula
  homepage 'https://github.com/petervanderdoes/gitflow'
  url 'https://github.com/petervanderdoes/gitflow/archive/1.4.2.zip'
  version '1.4.2'
  sha1 'bbfc065d0d72d87d7480a39db44b6f4684882945'

  head 'https://github.com/petervanderdoes/gitflow.git', :branch => 'develop'

  depends_on 'gnu-getopt'

  conflicts_with 'git-flow'

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  def caveats; <<-EOS.undent
    Create a ~/.gitflow_export file with the content 
      alias getopt="$(brew --prefix gnu-getopt)/bin/getopt"
     EOS
  end

  def test
    system "#{bin}/git-flow version"
  end
end
