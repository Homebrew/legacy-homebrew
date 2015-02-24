require "formula"

class GitReview < Formula
  homepage "https://git.openstack.org/cgit/openstack-infra/git-review"
  url "https://pypi.python.org/packages/source/g/git-review/git-review-1.24.tar.gz"
  sha1 "9183b505366b842cff32132ee88d8eff44bb7c89"

  bottle do
    cellar :any
    sha1 "98167df95c295b0f194f7d775d8c231173557067" => :yosemite
    sha1 "b66b3239d9079b451fbb665e718f201f6304ba8e" => :mavericks
    sha1 "877276d594a72aced623689b31c1d4ef6dabdd0a" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.5.0.tar.gz"
    sha1 "d60dfaaa0b4b62a6646fcb6c3954ea369317ca9f"
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
