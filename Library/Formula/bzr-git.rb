class BzrGit < Formula
  desc "Git repository support for Bazaar"
  homepage "https://launchpad.net/bzr-git"
  url "https://launchpad.net/bzr-git/trunk/0.6.8/+download/bzr-git-0.6.8.tar.gz"
  sha256 "b157db228717900d109990df349c656d2297803a20f88edb8280f2e9d73bfc27"

  depends_on 'bazaar'

  resource "dulwich" do
    url "https://github.com/jelmer/dulwich/archive/dulwich-0.12.0.tar.gz"
    sha256 "8ed49871294db0df9134890c0857234fec4fffde5124afbc0ba94be1c6445ff3"
  end

  def install
    resource("dulwich").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    (share/"bazaar/plugins/git").install Dir["*"]
  end

  def caveats; <<-EOS.undent
    In order to use this plugin you must set your PYTHONPATH in your ~/.bashrc:

      export PYTHONPATH="#{opt_libexec}/vendor/lib/python2.7/site-packages:$PYTHONPATH"

  EOS
  end

  test do
    assert_match /git 0\.6\.8/, shell_output("bzr plugins")
  end
end
