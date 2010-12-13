require 'formula'

class IscDhcp <Formula
  url 'ftp://ftp.isc.org/isc/dhcp/dhcp-3.1.3.tar.gz'
  homepage 'http://www.isc.org/software/dhcp'
  md5 '6ee8af8b283c95b3b4db5e88b6dd9a26'

  def install
    inreplace "Makefile.conf" do |s|
      s.gsub! "/usr", ""
      s.gsub! %r[man/cat(\d)], "man/man\\1"
    end

    system "./configure"
    system "make"
    system "make install DESTDIR=#{prefix}"
  end
end
