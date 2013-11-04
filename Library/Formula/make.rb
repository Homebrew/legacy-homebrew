require 'formula'

class Make < Formula
  homepage 'http://www.gnu.org/software/make'
  url 'http://ftpmirror.gnu.org/make/make-4.0.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/make/make-4.0.tar.gz'
  sha256 'fc42139fb0d4b4291929788ebaf77e2a4de7eaca95e31f3634ef7d4932051f69'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--program-prefix=g"

    system "make install"

  end
end
