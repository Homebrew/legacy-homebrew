require 'formula'

class Notmuch < Formula
  homepage "http://notmuchmail.org"
  url "http://notmuchmail.org/releases/notmuch-0.18.tar.gz"
  sha1 "bfbcdc340c4b0d544904b3a8ba70be4e819859d9"

  depends_on "pkg-config" => :build
  depends_on "emacs" => :optional
  depends_on "xapian"
  depends_on "talloc"
  depends_on "gmime"

  def install
    args = ["--prefix=#{prefix}"]
    if build.with? "emacs"
      ENV.deparallelize # Emacs and parallel builds aren't friends
      args << "--with-emacs"
    else
      args << "--without-emacs"
    end
    system "./configure", *args

    system "make", "V=1", "install"
  end
end
