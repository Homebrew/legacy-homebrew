class Magit < Formula
  desc "Emacs interface for Git"
  homepage "https://github.com/magit/magit"
  url "https://github.com/magit/magit/releases/download/2.1.0/magit-2.1.0.tar.gz"
  sha256 "835ba1cc461583b012671aea8271b8faf372324f0156706d5801cc1b0e533fc8"

  head "https://github.com/magit/magit.git", :shallow => false

  bottle do
    cellar :any
    sha256 "b8a6d761f1417cc1dd28907508f820491c0e0c3687b8a97b5ec5a81d67721719" => :yosemite
    sha256 "317e4c59fd1f3616ebb1dbc34beab2dbad9ccd4900b5d38dbf0e1378c3fc0de9" => :mavericks
    sha256 "5b9ae10a1253e28ccbf196e3cba3b6433e9253156dae8510344c94900bd0eb7a" => :mountain_lion
  end

  depends_on :emacs => "24.4"

  resource "dash" do
    url "https://github.com/magnars/dash.el/archive/2.11.0.tar.gz"
    sha256 "d888d34b9b86337c5740250f202e7f2efc3bf059b08a817a978bf54923673cde"
  end

  def install
    resource("dash").stage do
      (share/"emacs/site-lisp").install "dash.el"
    end

    (buildpath/"config.mk").write <<-EOS
      LOAD_PATH = -L #{buildpath}/lisp -L #{share}/emacs/site-lisp
    EOS

    args = %W[
      PREFIX=#{prefix}
      lispdir=#{share}/emacs/site-lisp
      docdir=#{doc}
    ]
    # Can't run `make install` alone without ENV.j1:
    # https://github.com/magit/magit/issues/1670
    system "make"
    system "make", "install", *args
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
