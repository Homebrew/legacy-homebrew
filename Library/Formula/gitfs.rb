class Gitfs < Formula
  homepage "http://www.presslabs.com/gitfs"
  url "https://github.com/PressLabs/gitfs/archive/0.2.5.tar.gz"
  sha1 "a54056c1ba4095daae63e3a6e3c2505943691a34"

  head "https://github.com/PressLabs/gitfs.git"

  bottle do
    cellar :any
    revision 1
    sha1 "5c28b1731d96c22d97115869704d3f3ecf5ef825" => :mavericks
    sha1 "fb78f15aaf634698e2ad0b985ecf5ed53d6b2e95" => :mountain_lion
  end

  depends_on "libgit2" => "with-libssh2"
  depends_on :osxfuse
  depends_on :python if MacOS.version <= :snow_leopard

  resource "fusepy" do
    url "https://pypi.python.org/packages/source/f/fusepy/fusepy-2.0.2.tar.gz"
    sha1 "d838388a122006614cd699cbcc5aa681194a5ae1"
  end

  # MUST update this every time libgit2 gets a major update.
  # Check if upstream have updated the requirements, and patch if necessary.
  resource "pygit2" do
    url "https://pypi.python.org/packages/source/p/pygit2/pygit2-0.22.0.tar.gz"
    sha1 "f60501293c2ed18224f880e419de10b6f52209d9"
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
    # This exactly replicates how upstream handled the last pygit2 update
    # https://github.com/PressLabs/gitfs/commit/8a53f6ba5ce2a4497779077a9249e7b4b5fcc32b
    # https://github.com/PressLabs/gitfs/pull/178
    inreplace "requirements.txt", "pygit2==0.21.4", "pygit2==0.22.0"

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

  test do
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    Pathname("test.py").write <<-EOS.undent
     import gitfs
     import pygit2
     pygit2.init_repository('testing/.git', True)
    EOS

    system "python", "test.py"
    assert File.exist?("testing/.git/config")
    cd "testing" do
      system "git", "remote", "add", "homebrew", "https://github.com/Homebrew/homebrew.git"
      assert_match /homebrew/, shell_output("git remote")
    end
  end
end
