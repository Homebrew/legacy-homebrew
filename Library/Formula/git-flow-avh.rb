require 'formula'

class GitFlowAvh < Formula
  homepage 'https://github.com/petervanderdoes/gitflow'
  url 'https://github.com/petervanderdoes/gitflow/archive/1.5.0.tar.gz'
  sha1 '3a9ac53606ab3306da53cba2abe9779b778dd8e0'

  head 'https://github.com/petervanderdoes/gitflow.git', :branch => 'develop'

  depends_on 'gnu-getopt'

  conflicts_with 'git-flow'

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  def caveats; <<-EOS.undent
    Create a ~/.gitflow_export file with the content
      export FLAGS_GETOPT_CMD="$(brew --prefix gnu-getopt)/bin/getopt"
     EOS
  end

  def test
    system "#{bin}/git-flow version"
  end
end
