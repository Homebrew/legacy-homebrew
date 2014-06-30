require 'formula'

class Gnupg < Formula
  homepage 'http://www.gnupg.org/'
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.17.tar.bz2'
  mirror 'http://mirror.switch.ch/ftp/mirror/gnupg/gnupg/gnupg-1.4.17.tar.bz2'
  sha1 '830c7f749ad92d6577c521addea5e5d920128d42'

  bottle do
    sha1 "4b841286cbcd16c0ae1a039a959dd1d29751072b" => :mavericks
    sha1 "e6cdc19b54a9d2b95fd38e76ea2d88cc52fe3dd5" => :mountain_lion
    sha1 "fe3780d0694e1cb01b17bcaadf95b7f3c02b0060" => :lion
  end

  option '8192', 'Build with support for private keys of up to 8192 bits'

  def install
    inreplace 'g10/keygen.c', 'max=4096', 'max=8192' if build.include? '8192'

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm"
    system "make"
    system "make check"

    # we need to create these directories because the install target has the
    # dependency order wrong
    [bin, libexec/'gnupg'].each(&:mkpath)
    system "make install"
  end
end
