class Magit < Formula
  desc "Emacs interface for Git"
  homepage "https://github.com/magit/magit"
  url "https://github.com/magit/magit/releases/download/2.3.0/magit-2.3.0.tar.gz"
  sha256 "a5cbf76635a801aa8cd75e5ec2171051328f23407dc46837004e00942ede202e"

  head "https://github.com/magit/magit.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "0773f335dd0306ecb269fbefb6f243065602217d032000b90c19da4380f5b584" => :el_capitan
    sha256 "fb8f610c5afd46576c60d332faafcdf50afa2b65526303e2dbccd64bd1b0b8e0" => :yosemite
    sha256 "138a269361bca3d5a909e1da5c99a67f48e25fac59836e1ac489633ccc473f2b" => :mavericks
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
