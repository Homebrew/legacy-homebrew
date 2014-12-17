require "formula"

class Gitfs < Formula
  homepage "http://www.presslabs.com/gitfs"
  url "https://github.com/PressLabs/gitfs/archive/0.2.5.tar.gz"
  sha1 "a54056c1ba4095daae63e3a6e3c2505943691a34"

  head "http://github.com/PressLabs/gitfs.git"

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

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec + "lib/python2.7/site-packages"

    install_args = "setup.py", "install", "--prefix=#{libexec}"

    resource("fusepy").stage { system "python", *install_args }
    resource("pygit2").stage { system "python", *install_args }

    system "python", *install_args

    (bin/"gitfs").write_env_script libexec/"bin/gitfs", :PYTHONPATH => ENV["PYTHONPATH"]
  end

  def caveats
    "gitfs clones repos in /var/lib/gitfs. You can either create it with \n" +
    "sudo mkdir -m 1777 /var/lib/gitfs or use another folder with the \n" +
    "repos_path argument."
  end

  test do
    system "gitfs"
  end
end
