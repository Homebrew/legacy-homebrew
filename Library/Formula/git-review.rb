require "formula"

class GitReview < Formula
  homepage "https://git.openstack.org/cgit/openstack-infra/git-review"
  url "https://pypi.python.org/packages/source/g/git-review/git-review-1.24.tar.gz"
  sha1 "9183b505366b842cff32132ee88d8eff44bb7c89"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.5.0.tar.gz"
    sha1 "d60dfaaa0b4b62a6646fcb6c3954ea369317ca9f"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/vendor/lib/python2.7/site-packages"
    resource("requests").stage do
      Language::Python.setup_install "python", libexec/"vendor"
    end

    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"
    Language::Python.setup_install "python", libexec

    man1.install gzip("git-review.1")

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "git init"
    system "git remote add gerrit https://github.com/Homebrew/homebrew.github.io"
    (testpath/".git/hooks/commit-msg").write("# empty - make git-review happy")
    (testpath/"foo").write("test file")
    system "git add foo"
    system "git commit -m \"test\""
    system "#{bin}/git-review", "--dry-run"
  end
end
