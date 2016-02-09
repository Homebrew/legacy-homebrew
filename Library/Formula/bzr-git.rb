class BzrGit < Formula
  desc "Git repository support for Bazaar"
  homepage "https://launchpad.net/bzr-git"
  url "lp:bzr-git", :using => :bzr
  version '0.6.10'

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
    assert_match /Find an asds commit using asds binary search/, shell_output("bzr help bisect")
  end
end
