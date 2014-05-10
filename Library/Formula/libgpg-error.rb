require 'formula'

class LibgpgError < Formula
  homepage 'http://www.gnupg.org/'
  url 'ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.13.tar.bz2'
  mirror 'http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.13.tar.bz2'
  sha1 '50fbff11446a7b0decbf65a6e6b0eda17b5139fb'

  bottle do
    cellar :any
    sha1 "1c975ce141fcc44543967cfd83984fcbb2a4bd7d" => :mavericks
    sha1 "f80ac1daca1a09be3a13a25ed6d0ce3a3940013e" => :mountain_lion
    sha1 "0ddec43a1845015a046f8ed4f924272eafc1cca7" => :lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
