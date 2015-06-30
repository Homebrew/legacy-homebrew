class Magit < Formula
  desc "Emacs interface for Git"
  homepage "https://github.com/magit/magit"

  url "https://github.com/magit/magit/releases/download/2.1.0/magit-2.1.0.tar.gz"
  sha256 "835ba1cc461583b012671aea8271b8faf372324f0156706d5801cc1b0e533fc8"

  head "https://github.com/magit/magit.git", :shallow => false

  bottle do
    cellar :any
    sha256 "cfbba4c7e7332fba7b60cf9484ae7979cf08e8d625545f924ececbeaa12418f6" => :yosemite
    sha256 "1ac752b649d17f26ff5ddf965d7125895455aeb069267295a4966528be5b9764" => :mavericks
    sha256 "c528977bcfef51e5a93e52b68ece520973be1aaa0d8a44f5adda7c99bcfc87b0" => :mountain_lion
  end

  depends_on :emacs => "24.4"

  resource "dash" do
    url "http://melpa.org/packages/dash-20150701.20.el"
    sha256 "4d4e41c343fe0b3056d5572b7f15ba0212e9ecefd1d735eb6b403321d3b982f5"
  end

  def install
    resource("dash").stage do
      (share/"emacs/site-lisp").install "dash-20150701.20.el" => "dash.el"
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
