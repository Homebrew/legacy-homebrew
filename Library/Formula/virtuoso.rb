require 'formula'

class Virtuoso < Formula
  homepage 'http://virtuoso.openlinksw.com/wiki/main/'
  url 'http://downloads.sourceforge.net/project/virtuoso/virtuoso/7.0.0/virtuoso-opensource-7.0.0.tar.gz'
  sha256 '7459ff8cefa42c051dc6790a8d34e31a4a873533314e24e529be90edd56f12fc'

  head do
    url 'https://github.com/openlink/virtuoso-opensource.git', :branch => 'develop/7'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on 'gawk' => :build

  skip_clean :la

  def install
    ENV.m64 if MacOS.prefer_64_bit?
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    NOTE: the Virtuoso server will start up several times on port 1111
    during the install process.
    EOS
  end
end
