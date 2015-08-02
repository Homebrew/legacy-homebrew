class HgFlow < Formula
  desc "Development model for mercurial inspired by git-flow"
  homepage "https://bitbucket.org/yujiewu/hgflow"
  url "https://bitbucket.org/yujiewu/hgflow/downloads/hgflow-v0.9.8.tar.bz2"
  sha1 "c0fad82a4849533c2832fbbdead299f22ae2d681"

  head "http://bitbucket.org/yujiewu/hgflow", :using => :hg, :branch => "develop"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :hg

  def install
    if build.head?
      libexec.install "src/hgflow.py" => "hgflow.py"
    else
      libexec.install "hgflow.py"
    end
  end

  def caveats; <<-EOS.undent
    1. Put following lines into your ~/.hgrc
    2. Restart your shell and try "hg flow".
    3. For more information go to http://bitbucket.org/yinwm/hgflow

        [extensions]
        flow = #{opt_prefix}/libexec/hgflow.py
        [flow]
        autoshelve = true

    EOS
  end

  test do
    (testpath/".hgrc").write <<-EOS.undent
      [extensions]
      flow = #{opt_prefix}/libexec/hgflow.py
      [flow]
      autoshelve = true
    EOS
    system "hg", "init"
    system "hg", "flow", "init", "-d"
  end
end
