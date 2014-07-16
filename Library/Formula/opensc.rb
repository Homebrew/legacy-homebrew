require 'formula'

class Opensc < Formula
  homepage 'https://github.com/OpenSC/OpenSC/wiki'
  url 'https://downloads.sourceforge.net/project/opensc/OpenSC/opensc-0.14.0/opensc-0.14.0.tar.gz'
  sha1 '4a898e351b0a6d2a5d81576daa7ebed45baf9138'

  bottle do
    sha1 "58e3ad4248bc4a10258560a6dd186ec1c86467a4" => :mavericks
    sha1 "d7b65a4e3c7997340dc102ff3196b594731b2977" => :mountain_lion
    sha1 "cf7e11fe49ca6910d9374211f6421980f7e0f94f" => :lion
  end

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
