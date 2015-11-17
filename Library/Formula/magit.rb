class Magit < Formula
  desc "Emacs interface for Git"
  homepage "https://github.com/magit/magit"
  url "https://github.com/magit/magit/releases/download/2.2.2/magit-2.2.2.tar.gz"
  sha256 "08e61898e23dbeb3a152d82e58fc9f6c769fe36d35d87617dcd1e69b2f91b3c6"

  head "https://github.com/magit/magit.git", :shallow => false

  bottle do
    cellar :any
    sha256 "048842721bb6f95aebd3ad00a81d5d62c87e8803252e4152e66652deeca6773f" => :yosemite
    sha256 "37969f18c4d5fa5c485670ffa27af504f38505f369447dc778771cc771ad61cb" => :mavericks
    sha256 "566bc0c62bf9633e7c8010877c2e884eacca730a0d3e626c2c22f0f964e09ca8" => :mountain_lion
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
