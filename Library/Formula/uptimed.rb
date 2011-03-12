require 'formula'

class Uptimed <Formula
  url 'http://podgorny.cz/uptimed/releases/uptimed-0.3.12.tar.bz2'
  homepage 'http://podgorny.cz/moin/Uptimed'
  md5 'c523d6434b672107ea00559bb38eb050'

  # Stripping symbols breaks uptimed
  skip_clean :all

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Per MacPorts
    inreplace "Makefile", "/var/spool/uptimed", "#{var}/uptimed"
    inreplace "libuptimed/urec.h", "/var/spool", var
    inreplace "etc/uptimed.conf-dist", "/var/run", "#{var}/uptimed"
    system "make install"
  end
end
