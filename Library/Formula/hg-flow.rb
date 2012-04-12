require 'formula'

class HgFlow < Formula
  homepage 'https://bitbucket.org/yinwm/hgflow/wiki/Home'
  url 'https://bitbucket.org/yinwm/hgflow/get/v0.3.tar.gz'
  md5 '0c3305bc349be31da76ef82460019d09'

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
