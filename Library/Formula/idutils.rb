class Idutils < Formula
  desc "ID database and query tools"
  homepage "https://www.gnu.org/s/idutils/"
  url "http://ftpmirror.gnu.org/idutils/idutils-4.6.tar.xz"
  mirror "https://ftp.gnu.org/gnu/idutils/idutils-4.6.tar.xz"
  sha256 "8181f43a4fb62f6f0ccf3b84dbe9bec71ecabd6dfdcf49c6b5584521c888aac2"

  bottle do
    sha256 "a0533ea0385b7aaae0222ed55e711fa5ce96194d7ab021f6a3209dc265a7fc95" => :yosemite
    sha256 "ff09770db3a3fd0c5bdb02387b1c41375a74c938b2d0de0e8f340aed2fcb24a8" => :mavericks
    sha256 "d078b7c9c5e7c011141d9f2665a9509c93996d49f301bc3ef49fc54fe0c4f663" => :mountain_lion
  end

  conflicts_with "coreutils", :because => "both install `gid` and `gid.1`"

  def install
    # Work around unremovable, nested dirs bug that affects lots of
    # GNU projects. See:
    # https://github.com/Homebrew/homebrew/issues/45273
    # https://github.com/Homebrew/homebrew/issues/44993
    # This is thought to be an El Capitan bug:
    # http://lists.gnu.org/archive/html/bug-tar/2015-10/msg00017.html
    if MacOS.version == :el_capitan
      ENV["gl_cv_func_getcwd_abort_bug"] = "no"
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--with-lispdir=#{share}/emacs/site-lisp/idutils"
    system "make", "install"
  end

  test do
    system bin/"mkid", "/usr/include"
    system bin/"lid", "FILE"
  end
end
