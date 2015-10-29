class Magit < Formula
  desc "Emacs interface for Git"
  homepage "https://github.com/magit/magit"
  url "https://github.com/magit/magit/releases/download/2.3.0/magit-2.3.0.tar.gz"
  sha256 "a5cbf76635a801aa8cd75e5ec2171051328f23407dc46837004e00942ede202e"

  head "https://github.com/magit/magit.git", :shallow => false

  bottle do
    cellar :any
    sha256 "048842721bb6f95aebd3ad00a81d5d62c87e8803252e4152e66652deeca6773f" => :yosemite
    sha256 "37969f18c4d5fa5c485670ffa27af504f38505f369447dc778771cc771ad61cb" => :mavericks
    sha256 "566bc0c62bf9633e7c8010877c2e884eacca730a0d3e626c2c22f0f964e09ca8" => :mountain_lion
  end

  depends_on :emacs => "24.4"

  resource "dash" do
    url "https://github.com/magnars/dash.el/archive/2.12.0.tar.gz"
    sha256 "272b337f31edb95c5aadc8e953d522bd307dc522588f246cc9157edee10b1a76"
  end

  resource "async" do
    url "https://github.com/jwiegley/emacs-async/archive/v1.5.tar.gz"
    sha256 "3126a6960796aa1bebe8a169ea5430df6ae5e18a34816c01b578f7c37c4bc216"
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
