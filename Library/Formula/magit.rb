class Magit < Formula
  desc "Emacs interface for Git"
  homepage "https://github.com/magit/magit"
  url "https://github.com/magit/magit/archive/2.2.0.tar.gz"
  sha256 "947c47961d5adbcbccda2ed50b7ef59e82ff91e089dedd645f14eeeb7d9acac9"

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

  resource "async" do
    url "https://github.com/jwiegley/emacs-async/archive/v1.4.tar.gz"
    sha256 "295d6d5dd759709ef714a7d05c54aa2934f2ffb4bb2e90e4434415f75f05473b"
  end

  def install
    resource("dash").stage { (share/"emacs/site-lisp/magit").install "dash.el" }
    resource("async").stage { (share/"emacs/site-lisp/magit").install Dir["*.el"] }

    (buildpath/"config.mk").write <<-EOS
      LOAD_PATH = -L #{buildpath}/lisp -L #{share}/emacs/site-lisp/magit
    EOS

    args = %W[
      PREFIX=#{prefix}
      docdir=#{doc}
    ]
    # Can't run `make install` alone without ENV.j1:
    # https://github.com/magit/magit/issues/1670
    system "make"
    system "make", "install", *args
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/magit")
      (load "magit")
      (magit-run-git "init")
    EOS
    system "emacs", "--batch", "-Q", "-l", "#{testpath}/test.el"
    File.exist? ".git"
  end
end
