class Magit < Formula
  desc "Emacs interface for Git"
  homepage "https://github.com/magit/magit"
  url "https://github.com/magit/magit/releases/download/1.4.1/magit-1.4.1.tar.gz"
  sha256 "e7b18d2acb7b79a622017726d7b2e48fcb893f3055ecd43b3672175599f97b2d"

  bottle do
    cellar :any
    sha256 "7cc9075b7384022feafc41cc993788491771e4d24c6a3b7e92618feffb95c281" => :yosemite
    sha256 "f4d97a2e79c5ea3b56ebb895fa8c6330d2256ad2d1f5d2b0de8255ed622751c1" => :mavericks
    sha256 "e4db292d7cc955b343cbacec8e0d1ed02195b4e0992945cff0bac38ce6c7ea32" => :mountain_lion
  end

  # see https://github.com/magit/magit/tree/master#its-magit--a-git-porcelain-inside-emacs
  # will require 24.4 upon release of magit 2.1.0
  depends_on :emacs => "23.2"

  # remove at 2.1.0
  resource "git-commit-mode" do
    url "https://github.com/magit/git-modes/raw/3423997a89f63eb4c8a4ce495928bc5951767932/git-commit-mode.el"
    sha256 "ed33f324e46ab81232bed5c38c4f8f794bd689f58aa49e98e386b628182b32e0"
  end

  # remove at 2.1.0
  resource "git-rebase-mode" do
    url "https://github.com/magit/git-modes/raw/3423997a89f63eb4c8a4ce495928bc5951767932/git-rebase-mode.el"
    sha256 "21670e2dcabadc18f2c2caff9b97d7affe1697a64d522a40fce6d8f1f5cd5ea5"
  end

  def install
    buildpath.install resource("git-commit-mode"),
                      resource("git-rebase-mode")
    system "make", "install", "PREFIX=#{prefix}"
    (share/"emacs/site-lisp").install "git-commit-mode.el",
                                      "git-rebase-mode.el"
  end

  def caveats; <<-EOS.undent
    Add the following to your Emacs init file to allow loading of packages installed by Homebrew:

    (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp")
      (require 'magit)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end
