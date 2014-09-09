require 'formula'

class GedaGaf < Formula
  homepage 'http://www.geda-project.org/'
  url 'http://ftp.geda-project.org/geda-gaf/stable/v1.8/1.8.2/geda-gaf-1.8.2.tar.gz'
  sha1 'c61edc04997fc12398534a346dac32d8fcdabcc1'

  devel do
    url 'http://ftp.geda-project.org/geda-gaf/unstable/v1.9/1.9.1/geda-gaf-1.9.1.tar.gz'
    sha1 '4b45085a187697e6c36e5f65a2a39b5a3b1a5f89'
  end

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on 'guile'
  depends_on 'gawk'
  depends_on :x11

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-update-xdg-database",
                          "--with-pcb-datadir=#{HOMEBREW_PREFIX}/share/pcb"
    system "make"
    system "make install"
  end
end

