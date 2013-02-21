require 'formula'

class Gnupg < Formula
  homepage 'http://www.gnupg.org/'
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.13.tar.bz2'
  sha1 '17a75c54d292bd0923f0a1817a1b02ded37d1de1'

  option 'idea', 'Build with the patented IDEA cipher'
  option '8192', 'Build with support for private keys of up to 8192 bits'

  def cflags
    cflags = ENV.cflags.to_s
    cflags += ' -std=gnu89 -fheinous-gnu-extensions' if ENV.compiler == :clang
    cflags
  end

  def install
    inreplace 'g10/keygen.c', 'max=4096', 'max=8192' if build.include? '8192'

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm"
    system "make", "CFLAGS=#{cflags}"
    system "make check"

    # we need to create these directories because the install target has the
    # dependency order wrong
    [bin, libexec/'gnupg'].each(&:mkpath)
    system "make install"
  end

  def caveats
    if build.include? 'idea' then <<-EOS.undent
      This build of GnuPG contains support for the patented IDEA cipher.
      Please read http://www.gnupg.org/faq/why-not-idea.en.html before using
      this software.

      You will then need to add the following line to your ~/.gnupg/gpg.conf or
        ~/.gnupg/options file:
          load-extension idea
      EOS
    end
  end
end
