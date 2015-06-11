class Magit < Formula
  desc "Emacs interface for Git"
  homepage "https://github.com/magit/magit"

  stable do
    url "https://github.com/magit/magit/archive/1.4.2.tar.gz"
    sha256 "460040e32a47a04222ea3bc3f78434308d8b0c6e82b03bfe3e6579068c54a2ab"

    depends_on :emacs => "23.2"

    resource "git-commit-mode" do
      url "https://github.com/magit/git-modes/raw/3423997a89f63eb4c8a4ce495928bc5951767932/git-commit-mode.el"
      sha256 "ed33f324e46ab81232bed5c38c4f8f794bd689f58aa49e98e386b628182b32e0"
    end

    resource "git-rebase-mode" do
      url "https://github.com/magit/git-modes/raw/3423997a89f63eb4c8a4ce495928bc5951767932/git-rebase-mode.el"
      sha256 "21670e2dcabadc18f2c2caff9b97d7affe1697a64d522a40fce6d8f1f5cd5ea5"
    end
  end

  head do
    url "https://github.com/magit/magit.git", :branch => "next"

    depends_on :emacs => "24.4"

    resource "dash" do
      url "http://melpa.org/packages/dash-20150611.922.el"
      sha256 "9a4de6d5adf5a976c4bca3d6c8ac653ba8c859b23e01b4e38e27820104c43043"
    end
  end

  bottle do
    cellar :any
    sha256 "7cc9075b7384022feafc41cc993788491771e4d24c6a3b7e92618feffb95c281" => :yosemite
    sha256 "f4d97a2e79c5ea3b56ebb895fa8c6330d2256ad2d1f5d2b0de8255ed622751c1" => :mavericks
    sha256 "e4db292d7cc955b343cbacec8e0d1ed02195b4e0992945cff0bac38ce6c7ea32" => :mountain_lion
  end

  def install
    if build.stable?
      buildpath.install resource("git-commit-mode"),
                        resource("git-rebase-mode")
      system "make", "install", "PREFIX=#{prefix}"
      (share/"emacs/site-lisp").install "git-commit-mode.el",
                                        "git-rebase-mode.el"
    else
      # Can't run `make install` alone without ENV.j1:
      # https://github.com/magit/magit/issues/1670
      system "make"
      system "make", "install", "PREFIX=#{prefix}"
      resource("dash").stage do
        (share/"emacs/site-lisp").install "dash-20150611.922.el" => "dash.el"
      end
    end
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
