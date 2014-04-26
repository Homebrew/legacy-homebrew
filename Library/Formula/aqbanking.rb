require 'formula'

class Aqbanking < Formula
  homepage 'http://www.aqbanking.de/'
  url 'http://www2.aquamaniac.de/sites/download/download.php?package=03&release=95&file=01&dummy=aqbanking-5.0.25.tar.gz'
  sha1 '80314a6f6114a0a3f0062161bb38effc0f1f4b62'
  head 'http://devel.aqbanking.de/svn/aqbanking/trunk'

  devel do
    url 'http://www2.aquamaniac.de/sites/download/download.php?package=03&release=115&file=01&dummy=aqbanking-5.4.3beta.tar.gz'
    sha1 'd3d4dac73794227041c8ec4a777f00ac17efd8ca'

    depends_on 'pkg-config' => :build
    depends_on 'libxmlsec1'
    depends_on 'libxslt'
    depends_on 'libxml2'
  end

  depends_on 'gettext'
  depends_on 'gmp'
  depends_on 'gwenhywfar' unless build.devel?
  depends_on 'ktoblzcheck' => :recommended

  def install
    ENV.j1
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cli",
                          "--with-gwen-dir=#{HOMEBREW_PREFIX}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    To build the devel version install all the dependencies first,
    then install the devel version of gwenhywfar separately,
    and install the devel version of aqbanking afterwards.

    brew install aqbanking --devel --only-dependencies
    brew install gwenhywfar --devel
    brew install aqbanking --devel
    EOS
  end
end
