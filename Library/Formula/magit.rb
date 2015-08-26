class Magit < Formula
  desc "Emacs interface for Git"
  homepage "https://github.com/magit/magit"
  url "https://github.com/magit/magit/archive/2.2.0.tar.gz"
  sha256 "947c47961d5adbcbccda2ed50b7ef59e82ff91e089dedd645f14eeeb7d9acac9"

  head "https://github.com/magit/magit.git", :shallow => false

  bottle do
    cellar :any
    revision 1
    sha256 "39bb319eaf4f0fcecec2e0e6d25b40d5f5837597dbc1fb687f1fea71f274d81c" => :yosemite
    sha256 "d87188bd976bb881697e69b014e1040cc18f9a69d28ad1d11e4f864284e829f4" => :mavericks
    sha256 "99717730946ae8952ae3c6873cf49f35c9a13c4808f8d4ee32f808f1bfba026b" => :mountain_lion
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
    system "make", "VERSION=#{version}"
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
