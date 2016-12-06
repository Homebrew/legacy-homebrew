class GitPr < Formula
  desc "Tool to fetch GitHub's pull requests"
  homepage "http://git-pr.readthedocs.org"
  url "https://pypi.python.org/packages/source/g/git-pr/git-pr-0.1.0.tar.gz"
  sha256 "146508b57d5b5c789b3bb76858a012a888af288c8a4383374838b7f894999580"

  head "https://github.com/ikalnitsky/git-pr.git"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    man1.install gzip("man/git-pr.1")

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "git", "init"
    system "git", "remote", "add", "origin", "https://github.com/ikalnitsky/git-pr.git"
    system "#{bin}/git-pr", "1"

    assert_equal "FAKE-PULL-REQUEST 42", File.read("FAKE-PULL-REQUEST").strip
  end
end
