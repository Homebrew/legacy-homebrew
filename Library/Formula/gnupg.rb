require 'formula'

class GnupgIdea <Formula
  head 'http://www.gnupg.dk/contrib-dk/idea.c.gz', :using  => NoUnzipCurlDownloadStrategy
  md5 '9dc3bc086824a8c7a331f35e09a3e57f'
end

class Gnupg <Formula
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.10.tar.bz2'
  homepage 'http://www.gnupg.org/'
  sha1 'fd1b6a5f3b2dd836b598a1123ac257b8f105615d'

  def options
    [["--idea", "Build with (patented) IDEA cipher"]]
  end

  def install
    if ARGV.include? '--idea'
      opoo "You are building with support for the patented IDEA cipher."
      d=Pathname.getwd
      GnupgIdea.new.brew { (d+'cipher').install Dir['*'] }
      system 'gunzip', 'cipher/idea.c.gz'
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm"
    system "make"
    system "make check"

    # we need to create these directories because the install target has the
    # dependency order wrong
    bin.mkpath
    (libexec+'gnupg').mkpath
    system "make install"
  end

  def caveats
    if ARGV.include? '--idea'
      <<-EOS.undent
        Please read http://www.gnupg.org/faq/why-not-idea.en.html before doing so.
        You will then need to add the following line to your ~/.gnupg/gpg.conf or
        ~/.gnupg/options file:
          load-extension idea
      EOS
    end
  end
end
