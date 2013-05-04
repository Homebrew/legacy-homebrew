require 'formula'

class Crm114 < Formula
  homepage 'http://crm114.sourceforge.net/'
  url 'http://crm114.sourceforge.net/tarballs/crm114-20100106-BlameMichelson.src.tar.gz'
  sha1 '621106ff14fa66a5a878a2c8fb0251ec483fc17b'

  depends_on 'tre'

  def install
    inreplace 'Makefile', 'LDFLAGS += -static -static-libgcc', ''
    bin.mkpath
    system "make", "prefix=#{prefix}", "install"
  end
end

