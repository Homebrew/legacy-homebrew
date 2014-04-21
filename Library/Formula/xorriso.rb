require 'formula'

class Xorriso < Formula
  homepage 'http://www.gnu.org/software/xorriso/'
  url 'http://ftpmirror.gnu.org/xorriso/xorriso-1.3.4.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/xorriso/xorriso-1.3.4.tar.gz'
  sha1 '2478393074b821c26dbadd294158b858054d5038'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/xorriso", "--help"
  end
end
