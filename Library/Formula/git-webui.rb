class GitWebui < Formula
  desc "A standalone local web based user interface for git repositories"
  homepage "https://github.com/alberthier/git-webui"
  url "https://github.com/alberthier/git-webui/archive/e8cbb49edeb09b4e5de65b1bf01d9cf672f9611d.tar.gz"
  sha256 "e89e6470e23459f59fd5a3cb0a42b40d2de35ebd78a44b9f0bc669564c72cda5"
  version "0.1.0" # as it appears on the project's package.json
  head "https://github.com/alberthier/git-webui.git"

  depends_on :python

  def install
    # there's no setup.py, the tarball contains a release dir with everything in it
    prefix.install Dir["release/*"]

    # ok, now lets symlink the executable to our local #{prefix}/bin path
    bin.install_symlink prefix/"libexec/git-core/git-webui"

    # and make sure the original script resolves the path to the assets correctly
    inreplace libexec/"git-core/git-webui", ".abspath(sys.argv[0])", ".realpath(sys.argv[0])"
  end

  test do
    system "git-webui", "--help"
  end
end
