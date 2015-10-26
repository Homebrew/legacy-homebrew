class GitPlus < Formula
  desc "Three git utilities: git multi, git relation, git old-branches"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://github.com/tkrajina/git-plus/archive/v0.1.0.tar.gz"
  sha256 "d7076ed3fd8e6e4bc2b93b9880adf58bea59b0f6fe95e05053f00247ae8cb609"
  head "https://github.com/tkrajina/git-plus.git"

  bottle :unneeded

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    site_packages = libexec/"lib/python2.7/site-packages"
    libexec_bin = libexec/"bin"

    ENV.prepend_create_path "PYTHONPATH", site_packages

    site_packages.install "gitutils.py"
    libexec_bin.install Dir["git-*"]

    bin.install Dir[libexec_bin/"*"]
    bin.env_script_all_files libexec_bin, :PYTHONPATH => ENV["PYTHONPATH"]
  end

  test do
    mkdir "testme" do
      system "git", "init"
      touch "README"
      system "git", "add", "README"
      system "git", "commit", "-m", "testing"
      rm "README"
    end

    assert_match /D README/, shell_output("#{bin}/git-multi")
  end
end
