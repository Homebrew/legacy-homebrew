class Magit < Formula
  desc "Emacs interface for Git"
  homepage "https://github.com/magit/magit"
  url "https://github.com/magit/magit/releases/download/2.2.1/magit-2.2.1.tar.gz"
  sha256 "b0e2c8c7ecf175f223c85849b8c9f80458b3f435ab9014851cbc446408914d2e"

  head "https://github.com/magit/magit.git", :shallow => false

  bottle do
    cellar :any
    sha256 "270e2504734160b1f1693e93d203d6f42a030b679b1a010a32db63e855def1e9" => :yosemite
    sha256 "de8082a62774c0fbd06e1d956486f0885e99cec4b44d3cef28b90f79f0932c11" => :mavericks
    sha256 "d647ceaa8f7c2bcc0518a0bbb0662f074418d44074cad6eab8441b31b8516f47" => :mountain_lion
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
      VERSION=#{version}
    ]
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
