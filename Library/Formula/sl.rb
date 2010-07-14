require 'formula'

class Sl <Formula
  url 'http://ftp.de.debian.org/debian/pool/main/s/sl/sl_3.03.orig.tar.gz'
  homepage 'http://packages.debian.org/source/oldstable/sl'
  md5 'd0d997b964bb3478f7f4968eee13c698'

  def install
    system "make"
    bin.install "sl"
    man1.install "sl.1"
  end
end
