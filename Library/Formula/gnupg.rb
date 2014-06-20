require 'formula'

class Gnupg < Formula
  homepage 'http://www.gnupg.org/'
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.16.tar.bz2'
  mirror 'http://mirror.switch.ch/ftp/mirror/gnupg/gnupg/gnupg-1.4.16.tar.bz2'
  sha1 '0bf5e475f3eb6f33d5474d017fe5bf66070e43f4'

  bottle do
    sha1 "eb0eb56c77ee61a43ec63393cf63493f0a04c4aa" => :mavericks
    sha1 "3f2e2ebd287d57d5c89565d087cfbaa1e2586f54" => :mountain_lion
    sha1 "a077b3a698ef320d82a05d5a538ec4860504251c" => :lion
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
