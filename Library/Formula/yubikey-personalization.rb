require 'formula'

class YubikeyPersonalization < Formula
  homepage 'https://www.yubico.com/develop/open-source-software/personalization-libraries/'
  url 'https://github.com/Yubico/yubikey-personalization/archive/v1.12.0.zip'
  sha1 'd0b12de3b2dcc83a11dd340e97a45aa2eb080fd0'

  depends_on 'libtool' => :build
  depends_on 'automake' => :build
  depends_on 'autoconf' => :build
  depends_on 'libyubikey'

  def install
    system "autoreconf", "--install"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/ykchalresp"
  end
end
