require 'formula'

class Meanwhile < Formula
  homepage 'http://meanwhile.sourceforge.net'
  url 'http://downloads.sourceforge.net/sourceforge/meanwhile/meanwhile-1.0.2.tar.gz'
  sha1 'e0e9836581da3c4a569135cb238eaa566c324540'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  def patches
    # fixes user status error: https://developer.pidgin.im/ticket/58
    # fixes glib includes: https://developer.pidgin.im/ticket/14773
    {:p0 => "https://gist.github.com/cjoelrun/5416702/raw/eac72bc2af1bc4ef933ba7179ad4e90fc627f1e9/meanwhile.patch"}
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-doxygen", "--disable-mailme"
    system "autoreconf", "-fi"
    system "make"
    system "make", "install"
  end
end
