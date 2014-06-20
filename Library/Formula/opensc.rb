require 'formula'

class Opensc < Formula
  homepage 'https://github.com/OpenSC/OpenSC/wiki'
  url 'https://downloads.sourceforge.net/project/opensc/OpenSC/opensc-0.13.0/opensc-0.13.0.tar.gz'
  sha1 '9285ccbed7b49f63e488c8fb1b3e102994a28218'

  head do
    url 'https://github.com/OpenSC/OpenSC.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  option 'with-man-pages', 'Build manual pages'

  depends_on 'docbook-xsl' if build.with? "man-pages"

  def install
    args = []

    if build.with? "man-pages"
      args << "--with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
    end

    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sm",
                          "--enable-openssl",
                          "--enable-pcsc",
                          *args

    system "make install"
  end
end
