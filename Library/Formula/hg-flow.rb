require 'formula'

class HgFlow < Formula
  homepage 'https://bitbucket.org/yinwm/hgflow/wiki/Home'
  url 'https://bitbucket.org/yinwm/hgflow/get/v0.3.tar.gz'
  sha1 '56250d4ce9f2e24a71e6a3c4b1f3e1d37bb64766'

  head "http://bitbucket.org/yinwm/hgflow", :using => :hg

  def install
    prefix.install 'src/hgflow/hgflow.py'
  end

  def caveats; <<-EOS.undent
    1. Put following lines into your ~/.hgrc
    2. Restart your shell and try "hg flow".
    3. For more information go to http://bitbucket.org/yinwm/hgflow

    [extensions]
    hgflow = #{prefix}/hgflow.py

    EOS
  end
end
