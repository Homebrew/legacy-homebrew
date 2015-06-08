require "formula"

class GitReview < Formula
  desc "Submit git branches to gerrit for review"
  homepage "https://git.openstack.org/cgit/openstack-infra/git-review"
  url "https://pypi.python.org/packages/source/g/git-review/git-review-1.24.tar.gz"
  sha1 "9183b505366b842cff32132ee88d8eff44bb7c89"
  revision 1

  bottle do
    cellar :any
    sha256 "a84e6f24cbcddb1f7516ce45cff341f2f70f17ebb7f3a4770ffea4dfd70823ab" => :yosemite
    sha256 "6820a4fff886ccde7796f1550699fc7507b5b27bbfd222e2f11cc3f6d16a9539" => :mavericks
    sha256 "08eebfba51435d1ab6ef64a5323d129d7bd0a94c0f8d98d75f205b9ccb291e3a" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.0.tar.gz"
    sha256 "1cdbed1f0e236f35ef54e919982c7a338e4fea3786310933d3a7887a04b74d75"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/vendor/lib/python2.7/site-packages"
    resource("requests").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    man1.install gzip("git-review.1")

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "git", "init"
    system "git", "remote", "add", "gerrit", "https://github.com/Homebrew/homebrew.github.io"
    (testpath/".git/hooks/commit-msg").write "# empty - make git-review happy"
    (testpath/"foo").write "test file"
    system "git", "add", "foo"
    system "git", "commit", "-m", "test"
    system "#{bin}/git-review", "--dry-run"
  end
end
