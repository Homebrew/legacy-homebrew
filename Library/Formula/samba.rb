require 'formula'

class Samba <Formula
  url 'http://www.samba.org/samba/ftp/samba-3.5.4.tar.gz'
  homepage 'http://www.samba.org/'
  md5 '22c8c977eaa18be50f3878c6d0e0c2f0'

  def install
    cd "source3" do
      system "./configure", "--disable-debug", "--without-readline", "--prefix=#{prefix}"
      system "make install"
    end
  end
end

