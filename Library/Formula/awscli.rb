require "formula"

class Awscli < Formula
  homepage "https://aws.amazon.com/cli/"
  url "https://pypi.python.org/packages/source/a/awscli/awscli-1.3.11.tar.gz"
  sha1 "18050c58ac8ce9553aed22ac0b8950df21d7c4fe"

  head do
    url "https://github.com/aws/aws-cli.git", :branch => :develop

    resource "botocore" do
      url "https://github.com/boto/botocore.git", :branch => :develop
    end

    resource "bcdoc" do
      url "https://github.com/boto/bcdoc.git", :branch => :develop
    end

    resource "jmespath" do
      url "https://github.com/boto/jmespath.git", :branch => :develop
    end
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "botocore" do
    url "https://pypi.python.org/packages/source/b/botocore/botocore-0.45.0.tar.gz"
    sha1 "b3bcf0065458a3fd5c172701cd88614b05ef41eb"
  end

  resource "bcdoc" do
    url "https://pypi.python.org/packages/source/b/bcdoc/bcdoc-0.12.2.tar.gz"
    sha1 "31b2a714c2803658d9d028c8edf4623fd0daaf18"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.6.1.tar.gz"
    sha1 "2a7941cc2233d9ad6d7d54dd5265d1eb9726c5a1"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/source/c/colorama/colorama-0.2.5.tar.gz"
    sha1 "87507210c5a7d400b27d23e8dd42734198663d66"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.11.tar.gz"
    sha1 "3894ebcbcbf8aa54ce7c3d2c8f05460544912d67"
  end

  resource "rsa" do
    url "https://bitbucket.org/sybren/python-rsa/get/version-3.1.2.tar.gz"
    sha1 "6a7515221e50ee87cfb54cb36e96f2a39df9badd"
  end

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    install_args = [ "setup.py", "install", "--prefix=#{libexec}" ]

    if build.head? then
      resource("jmespath").stage { system "python", *install_args }
    end

    resource("botocore").stage { system "python", *install_args }
    resource("bcdoc").stage { system "python", *install_args }
    resource("six").stage { system "python", *install_args }
    resource("colorama").stage { system "python", *install_args }
    resource("docutils").stage { system "python", *install_args }
    resource("rsa").stage { system "python", *install_args }

    system "python", "setup.py", "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"

    # Install zsh completion
    zsh_completion.install "bin/aws_zsh_completer.sh" => "_aws"

    # Install the examples
    (share+"awscli").install "awscli/examples"

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
