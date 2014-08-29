require 'formula'

class HgFlow < Formula
  homepage 'https://bitbucket.org/yujiewu/hgflow'
  url 'https://bitbucket.org/yujiewu/hgflow/downloads/hgflow-v0.9.6.tar.bz2'
  sha1 'f4f71daee139dcee882b9ab199f14b7214167498'

  head "http://bitbucket.org/yujiewu/hgflow", :using => :hg, :branch => 'develop'

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    if build.head?
      (lib/'python2.7/site-packages').install 'src/hgflow.py' => 'hgflow.py'
    else
      (lib/'python2.7/site-packages').install 'hgflow.py' => 'hgflow.py'
    end
  end

  def caveats; <<-EOS.undent
    1. Put following lines into your ~/.hgrc
    2. Restart your shell and try "hg flow".
    3. For more information go to http://bitbucket.org/yinwm/hgflow

        [extensions]
        hgflow=

    EOS
  end
end
