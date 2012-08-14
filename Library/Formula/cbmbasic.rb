require 'formula'

class Cbmbasic < Formula
  homepage 'http://cbmbasic.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cbmbasic/cbmbasic/1.0/cbmbasic-1.0.tgz'
  md5 '966cf93950809c3eace244af702cf895'

  def install
    system "make", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}"
    bin.install 'cbmbasic'
  end

  def test
    system "echo \"PRINT 1\" | #{bin}/cbmbasic"
  end
end
