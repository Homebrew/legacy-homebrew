require 'formula'

class Virtuoso < Formula
  homepage 'http://virtuoso.openlinksw.com/wiki/main/'
  url "https://downloads.sourceforge.net/project/virtuoso/virtuoso/7.1.0/virtuoso-opensource-7.1.0.tar.gz"
  sha1 "255d275d810bdb7cfa55fef46517724823c4c561"

  head do
    url 'https://github.com/openlink/virtuoso-opensource.git', :branch => 'develop/7'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on 'gawk' => :build

  conflicts_with 'unixodbc', :because => 'Both install `isql` binaries.'

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
