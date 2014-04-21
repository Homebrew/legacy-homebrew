require 'formula'

class Suricata < Formula
  homepage 'http://suricata-ids.org'
  url 'http://www.openinfosecfoundation.org/download/suricata-1.4.7.tar.gz'
  sha1 '33eb752ee40e4377e78465d089c5113b7295ce2f'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on 'pkg-config' => :build
  depends_on 'libmagic'
  depends_on 'libnet'
  depends_on 'libyaml'
  depends_on 'pcre'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
