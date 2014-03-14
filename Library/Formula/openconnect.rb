require 'formula'

class Openconnect < Formula
  homepage 'http://www.infradead.org/openconnect.html'
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-5.99.tar.gz"
  sha1 "3ac20e50f2700ff58d1635f210fc263d29cf7768"

  bottle do
    sha1 "444194b062852c484490c9a3b4b0e08247731525" => :mavericks
    sha1 "580e55016a4ff86300dc8fe2a24e353f9a7306cf" => :mountain_lion
    sha1 "ee6d840bb43176e32aab3f31d93d43451f42bfad" => :lion
  end

  head do
    url "git://git.infradead.org/users/dwmw2/openconnect.git", :shallow => false
    depends_on :autoconf => :build
    depends_on :automake => :build
    depends_on :libtool => :build
  end

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on "openssl"

  resource 'vpnc-script' do
    url 'http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/d2c5a77f3f0ea6ad80fc59158127d63ede81a6cb:/vpnc-script'
    sha1 '9915539c34393c1f8d7de9c3fc2c7396476bd998'
  end

  def install
    etc.install resource('vpnc-script')
    chmod 0755, "#{etc}/vpnc-script"

    if build.head?
      ln_s cached_download/".git", ".git"
      cp "autogen.sh", "autogen_modified.sh"
      inreplace "autogen_modified.sh", /libtoolize/, "glibtoolize"
      system "./autogen_modified.sh"
    end

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-vpnc-script=#{etc}/vpnc-script
    ]

    system "./configure", *args
    system "make install"
  end

  def caveats; <<-EOS.undent
    OpenConnect requires the use of a TUN/TAP driver.

    You can download one at http://tuntaposx.sourceforge.net/
    and install it prior to running OpenConnect.
    EOS
  end
end
