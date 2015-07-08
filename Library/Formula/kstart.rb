require 'formula'

class Kstart < Formula
  desc "Modified version of kinit that can use keytabs to authenticate"
  homepage 'http://www.eyrie.org/~eagle/software/kstart/'
  url 'http://archives.eyrie.org/software/kerberos/kstart-4.1.tar.gz'
  sha1 '09d0a5186d68f6f7d59340d40a79f27b5489d891'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/k5start", "-h"
  end
end
