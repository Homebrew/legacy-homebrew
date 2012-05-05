require 'formula'

class GnupgIdea < Formula
  head 'http://www.gnupg.dk/contrib-dk/idea.c.gz', :using  => :nounzip
  md5 '9dc3bc086824a8c7a331f35e09a3e57f'
end

class Gnupg < Formula
  homepage 'http://www.gnupg.org/'
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.12.tar.bz2'
  sha1 '9b78e20328d35525af7b8a9c1cf081396910e937'

  def options
    [
      ["--idea", "Build with (patented) IDEA cipher"],
      ["--8192", "Build with support for private keys up to 8192 bits"],
    ]
  end

  def install
    if ENV.compiler == :clang
      ENV.append 'CFLAGS', '-std=gnu89'
      ENV.append 'CFLAGS', '-fheinous-gnu-extensions'
    end

    if ARGV.include? '--idea'
      opoo "You are building with support for the patented IDEA cipher."
      d=Pathname.getwd
      GnupgIdea.new.brew { (d+'cipher').install Dir['*'] }
      system 'gunzip', 'cipher/idea.c.gz'
    end

    inreplace 'g10/keygen.c', 'max=4096', 'max=8192' if ARGV.include? '--8192'

    system "./configure", "--disable-dependency-tracking",
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
