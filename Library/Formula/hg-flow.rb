require 'formula'

class HgFlow < Formula
  homepage 'https://bitbucket.org/yinwm/hgflow'
  url 'https://bitbucket.org/yinwm/hgflow/downloads/hgflow-v0.4.pyhgflow-v0.4.py'
  sha1 '517a4e42b7a7ed68140903d4687180aa175aa3ef'

  head "http://bitbucket.org/yinwm/hgflow", :using => :hg, :branch => 'default'

  depends_on :python

  def install
    if build.head?
      cd 'src/hgflow'
      system 'python', 'setup.py', 'install', "--prefix=#{prefix}"
    else
      # That strange name seems like a bug. https://bitbucket.org/yinwm/hgflow/issue/24
      (lib/'python2.7/site-packages').install 'hgflow-v0.4.pyhgflow-v0.4.py' => 'hgflow.py'
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
