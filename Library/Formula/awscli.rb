class Awscli < Formula
  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://pypi.python.org/packages/source/a/awscli/awscli-1.8.3.tar.gz"
  mirror "https://github.com/aws/aws-cli/archive/1.8.3.tar.gz"
  sha256 "430124dce516e5466a290a8c9f6568185db18a15471f70b055b948218de50fe4"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e2ede5b5a40235da77e40407ea086428be75b4d31dc77218f50ae3b18234ed8" => :el_capitan
    sha256 "39fe43905bc3fc6f2fc074cbbe8674aeae2c5566f810301148cda1823a9f6240" => :yosemite
    sha256 "ea9853b620d52670b81d22813098fad466d9a207e67984f66f6579c2d6f2e759" => :mavericks
    sha256 "6b73a3e4d690046e0078b740b10f043f4ee6ea0250b65dd3174206e21a62f280" => :mountain_lion
  end

  head do
    url "https://github.com/aws/aws-cli.git", :branch => "develop"

    resource "botocore" do
      url "https://github.com/boto/botocore.git", :branch => "develop"
    end

    resource "bcdoc" do
      url "https://github.com/boto/bcdoc.git", :branch => "develop"
      url "https://github.com/boto/jmespath.git", :branch => "develop"
    end
  end

  # Use :python on Lion to avoid urllib3 warning
  # https://github.com/Homebrew/homebrew/pull/37240
  depends_on :python if MacOS.version <= :lion

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
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
    sha256 "cd5a12ee3dfa470283a020a35e69e83b0700d44fe413014fd35ad5584c5f5fd1"
  end

  resource "botocore" do
    url "https://pypi.python.org/packages/source/b/botocore/botocore-1.2.1.tar.gz"
    sha256 "3e3f75a52355d0d6feda98d2dd3345605227104174b45bc028507f055a90dd28"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "bcdoc" do
    url "https://pypi.python.org/packages/source/b/bcdoc/bcdoc-0.16.0.tar.gz"
    sha256 "f568c182e06883becf7196f227052435cffd45604700c82362ca77d3427b6202"
  end

  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.8.tar.gz"
    sha256 "5d33be7ca0ec5997d76d29ea4c33b65c00c0231407fff975199d7f40530b8347"
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
      http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
    EOS
  end

  test do
    system "#{bin}/aws", "--version"
  end
end
