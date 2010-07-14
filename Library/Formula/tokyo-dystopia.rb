require 'formula'

class TokyoDystopia <Formula
  url 'http://1978th.net/tokyodystopia/tokyodystopia-0.9.14.tar.gz'
  homepage 'http://1978th.net/tokyodystopia/'
  sha1 '51bf7e9320ed8fc5e20a110135ea36b0305aa7a5'

  depends_on 'tokyo-cabinet'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
