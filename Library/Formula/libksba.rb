require 'formula'

class Libksba < Formula
  homepage 'http://www.gnupg.org/related_software/libksba/index.en.html'
  url 'ftp://ftp.gnupg.org/gcrypt/libksba/libksba-1.3.0.tar.bz2'
  mirror 'http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/libksba/libksba-1.3.0.tar.bz2'
  sha1 '241afcb2dfbf3f3fc27891a53a33f12d9084d772'

  bottle do
    cellar :any
    sha1 "45f55ff042d927fda0d9ae290a509b1ceb285ce6" => :mavericks
    sha1 "e10515a7634d58e5948c78f378f0690e8e7274ac" => :mountain_lion
    sha1 "fbe0bd166c4766fcacbbee7df0320b77b8ef6f0b" => :lion
  end

  depends_on 'libgpg-error'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
