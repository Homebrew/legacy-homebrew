require 'formula'

class HgFlow < Formula
  url 'https://bitbucket.org/yinwm/hgflow/get/v0.3.tar.gz'
  version 'v0.3'
  homepage 'https://bitbucket.org/yinwm/hgflow/wiki/Home'
  head "http://bitbucket.org/yinwm/hgflow", :using => :hg
  md5 '0c3305bc349be31da76ef82460019d09'

  def install
    prefix.install Dir['*']
  end

  def caveats; <<-EOS.undent
    1. Put following lines into your ~/.hgrc
    2. Restart your shell and try "hg flow".
    3. For more information go to http://bitbucket.org/yinwm/hgflow

    [extensions]
    hgflow = #{prefix}/src/hgflow/hgflow.py
    
    EOS
  end
end
