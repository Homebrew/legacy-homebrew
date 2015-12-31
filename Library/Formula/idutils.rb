class Idutils < Formula
  desc "ID database and query tools"
  homepage "https://www.gnu.org/s/idutils/"
  url "http://ftpmirror.gnu.org/idutils/idutils-4.6.tar.xz"
  mirror "https://ftp.gnu.org/gnu/idutils/idutils-4.6.tar.xz"
  sha256 "8181f43a4fb62f6f0ccf3b84dbe9bec71ecabd6dfdcf49c6b5584521c888aac2"

  bottle do
    revision 1
    sha256 "5b148e92b0febab9a96211449f464385be7b2b6572d79001c87acb274095a6dc" => :el_capitan
    sha256 "b965eb4579741ab5721cb99f706b0601056055b8b9aa9178695e548cb3b9bf0c" => :yosemite
    sha256 "4625ef2ac2f7b2c87010880a0c31044ef850da4faded85c957b8ae23eeb7ab85" => :mavericks
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
