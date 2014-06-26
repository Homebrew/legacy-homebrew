require "formula"

# Note: Mutt has a large number of non-upstream patches available for it,
# some of which conflict with each other. These patches are also not kept
# up-to-date when new versions of mutt (occasionally) come out.
# To reduce Homebrew's maintainence burden, new patches are not being
# accepted for this formula. Mutt power-users are encouraged to copy the
# formula and modify it locally, adding needed patches.
class Mutt < Formula
  homepage "http://www.mutt.org/"
  url "ftp://ftp.mutt.org/mutt/mutt-1.5.23.tar.gz"
  mirror "http://fossies.org/linux/misc/mutt-1.5.23.tar.gz"
  sha1 "8ac821d8b1e25504a31bf5fda9c08d93a4acc862"
  revision 1

  bottle do
    revision 1
    sha1 "5aa656ffd793e57b26642b82c514e0195e32dd1e" => :mavericks
    sha1 "56302c5553e7bf5b31db3720ab22c6343c11c428" => :mountain_lion
    sha1 "8b7dad42c73723e25cb874e2654c8754218f580a" => :lion
  end

  head do
    url "http://dev.mutt.org/hg/mutt#default", :using => :hg

    resource "html" do
      url "http://dev.mutt.org/doc/manual.html", :using => :nounzip
    end
  end

  unless Tab.for_name("signing-party").used_options.include? "with-rename-pgpring"
    conflicts_with "signing-party",
      :because => "mutt installs a private copy of pgpring"
  end

  conflicts_with "tin",
    :because => "both install mmdf.5 and mbox.5 man pages"

  option "with-debug", "Build with debug option enabled"
  option "with-trash-patch", "Apply trash folder patch"
  option "with-s-lang", "Build against slang instead of ncurses"
  option "with-ignore-thread-patch", "Apply ignore-thread patch"
  option "with-pgp-verbose-mime-patch", "Apply PGP verbose mime patch"
  option "with-confirm-attachment-patch", "Apply confirm attachment patch"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "openssl"
  depends_on "tokyo-cabinet"
  depends_on "s-lang" => :optional
  depends_on "gpgme" => :optional

  patch do
    url "ftp://ftp.openbsd.org/pub/OpenBSD/distfiles/mutt/trashfolder-1.5.22.diff0.gz"
    sha1 "c597566c26e270b99c6f57e046512a663d2f415e"
  end if build.with? "trash-patch"

  # original source for this went missing, patch sourced from Arch at
  # https://aur.archlinux.org/packages/mutt-ignore-thread/
  patch do
    url "https://gist.githubusercontent.com/mistydemeo/5522742/raw/1439cc157ab673dc8061784829eea267cd736624/ignore-thread-1.5.21.patch"
    sha1 "dbcf5de46a559bca425028a18da0a63d34f722d3"
  end if build.with? "ignore-thread-patch"

  patch do
    url "https://raw.githubusercontent.com/psych0tik/mutt/73c09bc56e79605cf421a31c7e36958422055a20/debian/patches/features-old/patch-1.5.4.vk.pgp_verbose_mime"
    sha1 "a436f967aa46663cfc9b8933a6499ca165ec0a21"
  end if build.with? "pgp-verbose-mime-patch"

  patch do
    url "https://gist.githubusercontent.com/tlvince/5741641/raw/c926ca307dc97727c2bd88a84dcb0d7ac3bb4bf5/mutt-attach.patch"
    sha1 "94da52d50508d8951aa78ca4b073023414866be1"
  end if build.with? "confirm-attachment-patch"

  def install
    args = ["--disable-dependency-tracking",
            "--disable-warnings",
            "--prefix=#{prefix}",
            "--with-ssl=#{Formula['openssl'].opt_prefix}",
            "--with-sasl",
            "--with-gss",
            "--enable-imap",
            "--enable-smtp",
            "--enable-pop",
            "--enable-hcache",
            "--with-tokyocabinet",
            # This is just a trick to keep 'make install' from trying to chgrp
            # the mutt_dotlock file (which we can't do if we're running as an
            # unpriviledged user)
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

    (share/"doc/mutt").install resource("html") if build.head?
  end
end
