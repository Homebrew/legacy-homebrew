require 'formula'

class Mutt < Formula
  homepage 'http://www.mutt.org/'
  url 'ftp://ftp.mutt.org/mutt/devel/mutt-1.5.21.tar.gz'
  sha1 'a8475f2618ce5d5d33bff85c0affdf21ab1d76b9'

  head 'http://dev.mutt.org/hg/mutt#HEAD', :using => :hg

  option "with-bdb",                "Use BerkeleyDB4 if gdbm is not available"
  option "without-bdb",             "Don't use BerkeleyDB4 even if it is available"
  option "with-gdbm",               "Use gdbm as hcache backend"
  option "without-gdbm",            "Don't use gdbm even if it is available"
  option "with-qdbm",               "Use qdbm as hcache backend"
  option "without-qdbm",            "Don't use qdbm even if it is available"
  option "with-tokyocabinet",       "Use tokyocabinet as hcache backend"
  option "without-tokyocabinet",    "Don't use tokyocabinet even if it is available"
  option "enable-debug",            "Enable debugging support"
  option "enable-exact-address",    "Enable regeneration of email addresses"
  #option "enable-external-dotlock", "Force use of an external dotlock program"
  #option "disable-fcntl",           "Do NOT use fcntl() to lock files"
  #option "enable-flock",            "Use flock() to lock files"
  #option "disable-full-doc",        "Omit disabled variables"
  option "with-gnutls",             "Enable TLS support using gnutls"
  option "enable-gpgme",            "Enable GPGME support"
  option "with-gss",                "Compile in GSSAPI authentication for IMAP"
  option "enable-hcache",           "Enable header caching"
  option "disable-iconv",           "Disable iconv support"
  option "with-idn",                "Use GNU libidn for internationalized domain names"
  option "enable-imap",             "Enable IMAP support"
  #option "with-included-gettext",   "Use the GNU gettext library included here"
  option "disable-largefile",       "Omit support for large files"
  #option "enable-locales-fix",      "The result of isprint() is unreliable"
  #option "enable-mailtool",         "Enable Sun mailtool attachments support"
  #option "with-mixmaster",          "Include Mixmaster support"
  #option "enable-nfs-fix",          "Work around an NFS with broken attributes caching"
  option "enable-nls",              "Use Native Language Support"
  #option "disable-nls",             "Do not use Native Language Support"
  option "disable-pgp",             "Disable PGP support"
  option "enable-pop",              "Enable POP3 support"
  option "with-regex",              "Use the GNU regex library"
  option "with-sasl",               "Use SASL network security library"
  option "with-slang",              "Build against slang instead of ncurses"
  option "disable-smime",           "Disable SMIME support"
  option "enable-smtp",             "Include internal SMTP relay support"
  option "with-ssl",                "Enable TLS support using OpenSSL"
  #option "disable-warnings",        "Turn off compiler warnings (not recommended)"
  #option "without-wc-funcs",        "Do not use the system's wchar_t functions"
  # These are brew-specific ones:
  option "with-brewed-ssl",         "Use a brewed openssl instead of system openssl"
  option "with-old-brewflags",      "Use the flags passed by prior versions of this formula"

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
  depends_on 'berkeley-db4'  if build.include? 'with-bdb'
  depends_on 'qdbm'          => :optional
  depends_on 'tokyo-cabinet' if build.include? 'with-tokyocabinet' or
                                  build.include? 'with-old-brewflags'
  depends_on 'slang'         => :optional
  (depends_on 'gnutls'       => :optional) if build.head?
  depends_on 'gpgme'         if build.include? 'enable-gpgme'
  depends_on 'libidn'        if build.include? 'with-idn'
  depends_on 'gettext'       if build.include? 'enable-nls' # See below
  depends_on 'openssl'       if build.include? 'with-brewed-ssl' # New!


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
            # This is just a trick to keep 'make install' from trying to chgrp
            # the mutt_dotlock file (which we can't do if we're running as an
            # unpriviledged user)
            "--with-homespool=.mbox"]

    oldflags = ["--enable-pop",
                "--enable-imap",
                "--enable-smtp",
                "--enable-hcache",
                "--with-tokyocabinet",
                "--with-gss",
                "--with-ssl",
                "--with-sasl"]

    args += oldflags if build.include? 'with-old-brewflags'

    # Now for the myriad options one can pass.  Other than the hcache backends
    # and the NLS one, all the rest of these reflect mutt defaults.

    # hcache backends.  Both their 'with' and 'without' forms explicitly put in
    # here, because historically sometimes if you have more than one backend on
    # your system, mutt will pick one that isn't what you told it to pick.
    # Hence the 'without': force mutt to not do that.
    args << "--with-bdb"                if build.include? 'with-bdb'
    args << "--without-bdb"             if build.include? 'without-bdb'
    args << "--with-gdbm"               if build.include? 'with-gdbm'
    args << "--without-gdbm"            if build.include? 'without-gdbm'
    args << "--with-qdbm"               if build.include? 'with-qdbm'
    args << "--without-qdbm"            if build.include? 'without-qdbm'
    args << "--with-tokyocabinet"       if build.include? 'with-tokyocabinet'
    args << "--without-tokyocabinet"    if build.include? 'without-tokyocabinet'

    args << "--enable-debug"            if build.include? 'enable-debug'
    args << "--enable-exact-address"    if build.include? 'enable-exact-address'
    #args << "--enable-external-dotlock" if build.include? 'enable-external-dotlock'
    #args << "--disable-fcntl"           if build.include? 'disable-fcntl'
    #args << "--enable-flock"            if build.include? 'enable-flock'
    #args << "--disable-full-doc"        if build.include? 'disable-full-doc'
    args << "--with-gnutls"             if build.include? 'with-gnutls' and build.head?
    args << "--enable-gpgme"            if build.include? 'enable-gpgme'
    args << "--with-gss"                if build.include? 'with-gss'
    args << "--enable-hcache"           if build.include? 'enable-hcache'
    args << "--disable-iconv"           if build.include? 'disable-iconv'
    args << "--with-idn"                if build.include? 'with-idn'
    args << "--enable-imap"             if build.include? 'enable-imap'
    #args << "--with-included-gettext"   if build.include? 'with-included-gettext'
    args << "--disable-largefile"       if build.include? 'disable-largefile'
    #args << "--enable-locales-fix"      if build.include? 'enable-locales-fix'
    #args << "--enable-mailtool"         if build.include? 'enable-mailtool'
    #args << "--with-mixmaster"          if build.include? 'with-mixmaster'
    #args << "--enable-nfs-fix"          if build.include? 'enable-nfs-fix'
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
    args << "--enable-pop"              if build.include? 'enable-pop'
    args << "--with-regex"              if build.include? 'with-regex'
    args << "--with-sasl"               if build.include? 'with-sasl'
    args << "--with-slang"              if build.include? 'with-slang'
    args << "--disable-smime"           if build.include? 'disable-smime'
    args << "--enable-smtp"             if build.include? 'enable-smtp'
    args << "--with-ssl"                if build.include? 'with-ssl'
    #args << "--disable-warnings"        if build.include? 'disable-warnings'
    #args << "--without-wc-funcs"        if build.include? 'without-wc-funcs'

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
