require 'formula'

class Suricata < Formula
  homepage 'http://suricata-ids.org'
  url 'http://www.openinfosecfoundation.org/download/suricata-1.4.5.tar.gz'
  sha1 '723e111d19376dd352df4b50f3ee635a5328b01e'

  depends_on :autoconf
  depends_on :automake
  depends_on 'pkg-config' => :build
  depends_on 'libnet'
  depends_on 'pcre'
  depends_on 'libyaml'
  depends_on 'libtool' => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end
end
