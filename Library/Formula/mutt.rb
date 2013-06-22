require 'formula'

class Mutt < Formula
  homepage 'http://www.mutt.org/'
  url 'ftp://ftp.mutt.org/mutt/devel/mutt-1.5.21.tar.gz'
  sha1 'a8475f2618ce5d5d33bff85c0affdf21ab1d76b9'

  head 'http://dev.mutt.org/hg/mutt#HEAD', :using => :hg

  option "with-berkeley-db4",       "Use BerkeleyDB4 if gdbm is not available"
  option "without-berkeley-db4",    "Don't use BerkeleyDB4 even if it is available"
  option "with-gdbm",               "Use gdbm as hcache backend"
  option "without-gdbm",            "Don't use gdbm even if it is available"
  option "with-qdbm",               "Use qdbm as hcache backend"
  option "without-qdbm",            "Don't use qdbm even if it is available"
  option "with-tokyo-cabinet",       "Use tokyocabinet as hcache backend"
  option "without-tokyo-cabinet",    "Don't use tokyocabinet even if it is available"
  option "enable-debug",            "Enable debugging support"
  option "enable-exact-address",    "Enable regeneration of email addresses"
  option "with-gnutls",             "Enable TLS support using gnutls"
  option "with-gpgme",              "Enable GPGME support"
  option "with-gss",                "Compile in GSSAPI authentication for IMAP"
  option "disable-iconv",           "Disable iconv support"
  option "with-libidn",             "Use GNU libidn for internationalized domain names"
  option "disable-largefile",       "Omit support for large files"
  option "enable-nls",              "Use Native Language Support"
  option "disable-pgp",             "Disable PGP support"
  option "with-regex",              "Use the GNU regex library"
  option "with-slang",              "Build against slang instead of ncurses"
  option "disable-smime",           "Disable SMIME support"
  # These are for individually overriding the defaults.
  option "disable-smtp",            "Don't include internal SMTP relay support"
  option "disable-imap",            "Don't enable IMAP support"
  option "disable-pop",             "Don't enable POP3 support"
  option "disable-hcache",          "Don't enable header caching"
  option "without-ssl",             "Don't enable TLS support using OpenSSL"
  option "without-sasl",            "Don't use SASL network security library"
  option "without-gss",             "Don't compile in GSSAPI authentication for IMAP"
  # This one is brew-specific:
  option "with-brewed-ssl",         "Use a brewed openssl instead of system openssl"

  # Patches (sorted by name)
  option "with-confirm-attachment-patch", "Apply confirm attachment patch"
  option "with-confirm-crypt-hook-patch", "Apply confirm crypt hook patch"
  option "with-ignore-thread-patch",      "Apply ignore-thread patch"
  option "with-pgp-verbose-mime-patch",   "Apply PGP verbose mime patch"
  option "with-sidebar-patch",            "Apply sidebar (folder list) patch"
  option "with-trash-patch",              "Apply trash folder patch"


  # If (building from HEAD & Lion or greater), need both autoconf and automake:
  if build.head? and MacOS.version >= :lion
    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
  end

  # Don't let the brewer enable header caching without selecting a backend.  The
  # build will choke if there is no backend on the system.  Better to error-out
  # and tell the brewer what will happen up-front.
  if build.include? 'enable-hcache'
    if !build.include? 'with-gdbm' and !build.include? 'with-bdb' and
       !build.include? 'with-qdbm' and !build.include? 'with-tokyocabinet'
      puts "\n"
      onoe <<-EOS.undent
          If you --enable-hcache, you must enable a backend.
          Possible choices are: --with-[gdbm,bdb,qdbm,tokyocabinet].
          Whichever one you pick will be brewed for you.
      EOS
      exit 1
    end
  end

  # A non-HEAD build with gnutls will fail, at least on 10.8.4.  A HEAD build
  # will work just fine.  Better to tell the brewer up-front instead of waiting
  # for a build to crap out.
  if build.include? 'with-gnutls' and !build.head?
    puts "\n"
    onoe <<-EOS.undent
      You tried to build --with-gnutls, which doesn't work
      with a plain 1.5.21.  You can get gnutls if you include
      --HEAD among your options passed to brew.
    EOS
    exit 1
  end

  depends_on 'gdbm'          => :optional
  depends_on 'berkeley-db4'  => :optional
  depends_on 'qdbm'          => :optional
  depends_on 'tokyo-cabinet' => :optional
  depends_on 'gettext'       if build.include? 'enable-nls' # See below
  depends_on 'gnutls'        => :optional if build.head?
  depends_on 'gpgme'         => :optional
  depends_on 'libidn'        => :optional
  depends_on 'openssl'       if build.include? 'with-brewed-ssl' # New!
  depends_on 'slang'         => :optional


  # Sort by patch name
  def patches
    urls = [
      # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=182069
      ['with-confirm-attachment-patch', 'https://gist.github.com/tlvince/5741641/raw/c926ca307dc97727c2bd88a84dcb0d7ac3bb4bf5/mutt-attach.patch'],
      # http://www.woolridge.ca/mutt/confirm-crypt-hook.html
      ['with-confirm-crypt-hook-patch', 'http://www.woolridge.ca/mutt/patches/patch-1.5.6.dw.confirm-crypt-hook.1'],
      # original source for this went missing, patch sourced from Arch at
      # https://aur.archlinux.org/packages/mutt-ignore-thread/
      ['with-ignore-thread-patch', 'https://gist.github.com/mistydemeo/5522742/raw/1439cc157ab673dc8061784829eea267cd736624/ignore-thread-1.5.21.patch'],
      ['with-pgp-verbose-mime-patch',
        'http://patch-tracker.debian.org/patch/series/dl/mutt/1.5.21-6.2/features-old/patch-1.5.4.vk.pgp_verbose_mime'],
      ['with-sidebar-patch', 'http://lunar-linux.org/~tchan/mutt/patch-1.5.21.sidebar.20130219.txt'],
      ['with-trash-patch', 'http://patch-tracker.debian.org/patch/series/dl/mutt/1.5.21-6.2/features/trash-folder'],
    ]

    if build.include? "with-ignore-thread-patch" and build.include? "with-sidebar-patch"
      puts "\n"
      onoe "The ignore-thread-patch and sidebar-patch options are mutually exlusive. Please pick one"
      exit 1
    end

    p = []
    urls.each do |u|
      p << u[1] if build.include? u[0]
    end

    return p
  end


  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--enable-pop",
            "--enable-imap",
            "--enable-smtp",
            "--enable-hcache",
            "--with-gss",
            "--with-ssl",
            "--with-sasl",
            # This is just a trick to keep 'make install' from trying to chgrp
            # the mutt_dotlock file (which we can't do if we're running as an
            # unpriviledged user)
            "--with-homespool=.mbox"]

    # Now for the myriad options one can pass.  Other than the hcache backends
    # and the NLS one, all the rest of these reflect mutt defaults.

    # hcache backends.  Both their 'with' and 'without' forms explicitly put in
    # here, because historically sometimes if you have more than one backend on
    # your system, mutt will pick one that isn't what you told it to pick.
    # Hence the 'without': force mutt to not do that.
    args << "--with-bdb"                if build.include? 'with-berkeley-db4'
    args << "--without-bdb"             if build.include? 'without-berkeley-db4'
    args << "--with-gdbm"               if build.include? 'with-gdbm'
    args << "--without-gdbm"            if build.include? 'without-gdbm'
    args << "--with-qdbm"               if build.include? 'with-qdbm'
    args << "--without-qdbm"            if build.include? 'without-qdbm'
    args << "--with-tokyocabinet"      unless build.include? 'without-tokyo-cabinet'
    args << "--without-tokyocabinet"   if build.include? 'without-tokyo-cabinet'

    args << "--enable-debug"            if build.include? 'enable-debug'
    args << "--enable-exact-address"    if build.include? 'enable-exact-address'
    args << "--with-gnutls"             if build.include? 'with-gnutls' and build.head?
    args << "--enable-gpgme"            if build.include? 'with-gpgme'
    args << "--disable-iconv"           if build.include? 'disable-iconv'
    args << "--with-idn"                if build.include? 'with-libidn'
    args << "--enable-imap"             if build.include? 'enable-imap'
    args << "--disable-largefile"       if build.include? 'disable-largefile'
    args << "--enable-nls"              if build.include? 'enable-nls'

    # NLS will be off by default, on if brewer asks for it.  The alternative is
    # to force the brewer to brew gettext, which would be truly lamentable.
    # With no gettext, there's an error because mutt can't find libintl.h.  This
    # is true from Tiger to Mountain Lion.  The error is called "fatal" by
    # clang, though the build process continues and you simply get a mutt
    # without an actually functioning NLS.  I seem to recall that 'mutt -v' will
    # *think* you have NLS.
    args << "--disable-nls"             unless build.include? 'enable-nls'

    args << "--disable-pgp"             if build.include? 'disable-pgp'
    args << "--with-regex"              if build.include? 'with-regex'
    args << "--with-slang"              if build.include? 'with-slang'
    args << "--disable-smime"           if build.include? 'disable-smime'
    # These will invidually override the defaults.
    args << "--disable-smtp"            if build.include? 'disable-smtp'
    args << "--disable-imap"            if build.include? 'disable-imap'
    args << "--disable-pop"             if build.include? 'disable-pop'
    args << "--disable-hcache"          if build.include? 'disable-hcache'
    args << "--without-ssl"             if build.include? 'without-ssl'
    args << "--without-sasl"            if build.include? 'without-sasl'
    args << "--without-gss"             if build.include? 'without-gss'


    # Mutt does NOT require a brewed openssl.  Let nobody alter this with a
    # gratuitous depends_on.
    if build.include? 'with-brewed-ssl'
      args << "--with-ssl=#{Formula.factory("openssl").opt_prefix}"
    end

    if build.head?
      system "./prepare", *args
    else
      system "./configure", *args
    end

    system "make"
    system "make", "install"
  end

  def caveats
    s = ''
    if build.head?
      s += <<-EOS.undent
        Unless you have docbook installed and setup properly, the docs
        didn't build.  If you want them, grab them from

          http://dev.mutt.org/doc/manual.html

        and put them here:

          #{share}/doc/mutt/manual.html
      EOS
    end
    return s.empty? ? nil : s
  end

end
