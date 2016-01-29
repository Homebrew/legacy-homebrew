class Awscli < Formula
  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://pypi.python.org/packages/source/a/awscli/awscli-1.10.1.tar.gz"
  mirror "https://github.com/aws/aws-cli/archive/1.10.1.tar.gz"
  sha256 "6b738f7fc6af7ab9c759b7efb5decde71970990061b2df169b14bec89c452c95"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc74fefe12bbd4599c4c6f843795eb0841d423215947f71df2351c8239a0a85e" => :el_capitan
    sha256 "faaffad321b9164622071c31f6efef39041879a2c167677d9cc1a42aacd9c569" => :yosemite
    sha256 "90f2bc98f7e18cf73180d6bb3654b006413b7128484ea9777a0cf4afbbf30665" => :mavericks
  end

  head do
    url "https://github.com/aws/aws-cli.git", :branch => "develop"

    resource "botocore" do
      url "https://github.com/boto/botocore.git", :branch => "develop"
    end

    resource "jmespath" do
      url "https://github.com/boto/jmespath.git", :branch => "develop"
    end
  end

  # Use :python on Lion to avoid urllib3 warning
  # https://github.com/Homebrew/homebrew/pull/37240
  depends_on :python if MacOS.version <= :lion

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
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
    url "https://pypi.python.org/packages/source/j/jmespath/jmespath-0.9.0.tar.gz"
    sha256 "08dfaa06d4397f283a01e57089f3360e3b52b5b9da91a70e1fd91e9f0cdd3d3d"
  end

  resource "botocore" do
    url "https://pypi.python.org/packages/source/b/botocore/botocore-1.3.23.tar.gz"
    sha256 "d2e067bdb3e9b5c26821efc8517a9ced4f9d5f4cd30de14585ed1fe0eb552a02"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "rsa" do
    url "https://pypi.python.org/packages/source/r/rsa/rsa-3.2.3.tar.gz"
    sha256 "14db288cc40d6339dedf60d7a47053ab004b4a8976a5c59402a211d8fc5bf21f"
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
    pkgshare.install "awscli/examples"

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
      https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
    EOS
  end

  test do
    system "#{bin}/aws", "--version"
  end
end
