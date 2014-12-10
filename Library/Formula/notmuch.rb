require "formula"

class Notmuch < Formula
  homepage "http://notmuchmail.org"
  url "http://notmuchmail.org/releases/notmuch-0.18.1.tar.gz"
  sha1 "ad82d6d5355594c4cab3c6d28c70ae4993acbec9"

  bottle do
    cellar :any
    sha1 "c2abec535c387b43719bb5775d2f5c574a0b26a6" => :mavericks
    sha1 "60839b86690a3b8d095b98a788dedef6163b779e" => :mountain_lion
    sha1 "74cbad02dae99188baa190c6f3a8175bcea10e14" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "emacs" => :optional
  depends_on "xapian"
  depends_on "talloc"
  depends_on "gmime"

  # Requires zlib >= 1.2.5.2
  resource "zlib" do
    url "http://zlib.net/zlib-1.2.8.tar.gz"
    sha1 "a4d316c404ff54ca545ea71a27af7dbc29817088"
  end

  def install
    resource("zlib").stage do
      system "./configure", "--prefix=#{buildpath}/zlib", "--static"
      system "make", "install"
      ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/zlib/lib/pkgconfig"
    end

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
