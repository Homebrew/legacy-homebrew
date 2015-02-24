require "formula"

class Gitfs < Formula
  homepage "http://www.presslabs.com/gitfs"
  url "https://github.com/PressLabs/gitfs/archive/0.2.5.tar.gz"
  sha1 "a54056c1ba4095daae63e3a6e3c2505943691a34"

  head "https://github.com/PressLabs/gitfs.git"

  bottle do
    cellar :any
    sha1 "4787280d565c24d411c22fcb62c194eb0a7eebe7" => :mavericks
    sha1 "1ff9f5341a0524aeba3d9cb39e24085acd1d6606" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  depends_on "libgit2" => "with-libssh2"
  depends_on :osxfuse

  resource "fusepy" do
    url "https://pypi.python.org/packages/source/f/fusepy/fusepy-2.0.2.tar.gz"
    sha1 "d838388a122006614cd699cbcc5aa681194a5ae1"
  end

  resource "pygit2" do
    url "https://pypi.python.org/packages/source/p/pygit2/pygit2-0.21.4.tar.gz"
    sha1 "f7d677de26c56ab0f23edd7fe6812ec23b79b8f6"
  end

  resource "atomiclong" do
    url "https://pypi.python.org/packages/source/a/atomiclong/atomiclong-0.1.1.tar.gz"
    sha1 "4b3cab22c1910426fff41eef4cc69f418ec78a35"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-0.8.6.tar.gz"
    sha1 "4e82390201e6f30e9df8a91cd176df19b8f2d547"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.10.tar.gz"
    sha1 "378a7a987d40e2c1c42cad0b351a6fc0a51ed004"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[fusepy pygit2 atomiclong cffi pycparser].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    gitfs clones repos in /var/lib/gitfs. You can either create it with
    sudo mkdir -m 1777 /var/lib/gitfs or use another folder with the
    repo_path argument.

    Also make sure OSXFUSE is properly installed by running brew info osxfuse.
    EOS
  end
end
