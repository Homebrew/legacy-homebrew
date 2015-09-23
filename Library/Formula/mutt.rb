# Note: Mutt has a large number of non-upstream patches available for
# it, some of which conflict with each other. These patches are also
# not kept up-to-date when new versions of mutt (occasionally) come
# out.
#
# To reduce Homebrew's maintenance burden, new patches are not being
# accepted for this formula. We would be very happy to see members of
# the mutt community maintain a more comprehesive tap with better
# support for patches.

class Mutt < Formula
  desc "Mongrel of mail user agents (part elm, pine, mush, mh, etc.)"
  homepage "http://www.mutt.org/"
  url "https://bitbucket.org/mutt/mutt/downloads/mutt-1.5.24.tar.gz"
  mirror "ftp://ftp.mutt.org/pub/mutt/mutt-1.5.24.tar.gz"
  sha256 "a292ca765ed7b19db4ac495938a3ef808a16193b7d623d65562bb8feb2b42200"

  bottle do
    sha256 "81c99d9cceb46d0c4c6f12aaceb29daa1e27aa83ef67c8201428e2757229b1e1" => :el_capitan
    sha256 "9d83e71eeca14f5494a07abd68b6a723928cf415157dbf070461a10d0a0d89ae" => :yosemite
    sha256 "28b3aa2d69d4eb12da355f7639c3e7eb4124337ff0c0d91477b4dd75c161ac67" => :mavericks
    sha256 "3ed3daff645991c2f4a7f3eb91b6f65facced496e4d1aa28584f1cad29081763" => :mountain_lion
  end

  head do
    url "http://dev.mutt.org/hg/mutt#default", :using => :hg

    resource "html" do
      url "http://dev.mutt.org/doc/manual.html", :using => :nounzip
    end
  end

  unless Tab.for_name("signing-party").with? "rename-pgpring"
    conflicts_with "signing-party",
      :because => "mutt installs a private copy of pgpring"
  end

  conflicts_with "tin",
    :because => "both install mmdf.5 and mbox.5 man pages"

  option "with-debug", "Build with debug option enabled"
  option "with-s-lang", "Build against slang instead of ncurses"
  option "with-ignore-thread-patch", "Apply ignore-thread patch"
  option "with-confirm-attachment-patch", "Apply confirm attachment patch"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "openssl"
  depends_on "tokyo-cabinet"
  depends_on "s-lang" => :optional
  depends_on "gpgme" => :optional

  # original source for this went missing, patch sourced from Arch at
  # https://aur.archlinux.org/packages/mutt-ignore-thread/
  if build.with? "ignore-thread-patch"
    patch do
      url "https://gist.githubusercontent.com/mistydemeo/5522742/raw/1439cc157ab673dc8061784829eea267cd736624/ignore-thread-1.5.21.patch"
      sha256 "7290e2a5ac12cbf89d615efa38c1ada3b454cb642ecaf520c26e47e7a1c926be"
    end
  end

  if build.with? "confirm-attachment-patch"
    patch do
      url "https://gist.githubusercontent.com/tlvince/5741641/raw/c926ca307dc97727c2bd88a84dcb0d7ac3bb4bf5/mutt-attach.patch"
      sha256 "da2c9e54a5426019b84837faef18cc51e174108f07dc7ec15968ca732880cb14"
    end
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-warnings",
            "--prefix=#{prefix}",
            "--with-ssl=#{Formula["openssl"].opt_prefix}",
            "--with-sasl",
            "--with-gss",
            "--enable-imap",
            "--enable-smtp",
            "--enable-pop",
            "--enable-hcache",
            "--with-tokyocabinet",
            # This is just a trick to keep 'make install' from trying
            # to chgrp the mutt_dotlock file (which we can't do if
            # we're running as an unprivileged user)
            "--with-homespool=.mbox"]
    args << "--with-slang" if build.with? "s-lang"
    args << "--enable-gpgme" if build.with? "gpgme"

    if build.with? "debug"
      args << "--enable-debug"
    else
      args << "--disable-debug"
    end

    system "./prepare", *args
    system "make"
    system "make", "install"

    doc.install resource("html") if build.head?
  end

  test do
    system bin/"mutt", "-D"
  end
end
