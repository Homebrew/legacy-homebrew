class Magit < Formula
  desc "Emacs interface for Git"
  homepage "https://github.com/magit/magit"
  url "https://github.com/magit/magit/archive/2.2.0.tar.gz"
  sha256 "947c47961d5adbcbccda2ed50b7ef59e82ff91e089dedd645f14eeeb7d9acac9"

  head "https://github.com/magit/magit.git", :shallow => false

  bottle do
    cellar :any
    sha256 "830752375a231adf04b97293ebc12189c94e99fbe59bbd644cdb471729e139d2" => :yosemite
    sha256 "c4a4c50f8d85c07e88e79e9d455086f61e08aeb619fd8db6c618b4d1aeb8dddf" => :mavericks
    sha256 "5b81cdfb924d4a259f759469947ac80cfab38c77bdfd24d46b9bbf9ec9c508ab" => :mountain_lion
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
