class Awscli < Formula
  homepage "https://aws.amazon.com/cli/"
  url "https://pypi.python.org/packages/source/a/awscli/awscli-1.7.32.tar.gz"
  sha256 "50f914d752700c47e6567d1f17ee64c8d5efbe1974da46c03cf7d85e080f71b5"

  bottle do
    cellar :any
    sha256 "90cff215e5207d949258c5fbb045565e746570261666090642e3b23ce070b2c8" => :yosemite
    sha256 "b505972bf1bb1a6f40fe106c35682773de14360c85d6cf6d396f32bf285fac14" => :mavericks
    sha256 "d95c8ef272379ef8d969a65c227b3b7a2e179537b6e2ff692475e2bee97a862a" => :mountain_lion
  end

  head do
    url "https://github.com/aws/aws-cli.git", :branch => "develop"

    resource "botocore" do
      url "https://github.com/boto/botocore.git", :branch => "develop"
    end

    resource "bcdoc" do
      url "https://github.com/boto/bcdoc.git", :branch => "develop"
    end

    resource "jmespath" do
      url "https://github.com/boto/jmespath.git", :branch => "develop"
    end
  end

  # Use :python on Lion to avoid urllib3 warning
  # https://github.com/Homebrew/homebrew/pull/37240
  depends_on :python if MacOS.version <= :lion

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha1 "d168e6d01f0900875c6ecebc97da72d0fda31129"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.2.tar.gz"
    sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/source/c/colorama/colorama-0.3.3.tar.gz"
    sha256 "eb21f2ba718fbf357afdfdf6f641ab393901c7ca8d9f37edd0bee4806ffa269c"
  end

  resource "jmespath" do
    url "https://pypi.python.org/packages/source/j/jmespath/jmespath-0.7.1.tar.gz"
    sha1 "10cbbf7f1a892d2c4fce7f7e84bb91e9108fcf45"
  end

  resource "botocore" do
    url "https://pypi.python.org/packages/source/b/botocore/botocore-1.0.0b1.tar.gz"
    sha256 "c4665a00dad68bfdfda02df9cad7b93bb391430c043f01261a964f86fa1b41eb"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha1 "002450621b33c5690060345b0aac25bc2426d675"
  end

  resource "bcdoc" do
    url "https://pypi.python.org/packages/source/b/bcdoc/bcdoc-0.14.0.tar.gz"
    sha256 "68aecc8e14151266316562c6a50605b8efa33f18f8023e303fb20a1b346e53e8"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.7.tar.gz"
    sha1 "e32b91c5a5d9609fb1d07d8685a884bab22ca6d0"
  end

  resource "rsa" do
    url "https://pypi.python.org/packages/source/r/rsa/rsa-3.1.4.tar.gz"
    sha256 "e2b0b05936c276b1edd2e1525553233b666df9e29b5c3ba223eed738277c82a0"
  end

  def install
    ENV["PYTHONPATH"] = libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    system "python", *Language::Python.setup_install_args(libexec)

    # Install zsh completion
    zsh_completion.install "bin/aws_zsh_completer.sh" => "_aws"

    # Install the examples
    (share+"awscli").install "awscli/examples"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples

    Add the following to ~/.bashrc to enable bash completion:
      complete -C aws_completer aws

    Add the following to ~/.zshrc to enable zsh completion:
      source #{HOMEBREW_PREFIX}/share/zsh/site-functions/_aws

    Before using awscli, you need to tell it about your AWS credentials.
    The easiest way to do this is to run:
      aws configure

    More information:
      http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
    EOS
  end

  test do
    system "#{bin}/aws", "--version"
  end
end
