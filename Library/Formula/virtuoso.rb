require 'formula'

class Virtuoso < Formula
  homepage 'http://virtuoso.openlinksw.com/wiki/main/'
  url 'http://downloads.sourceforge.net/project/virtuoso/virtuoso/6.1.7/virtuoso-opensource-6.1.7.tar.gz'
  sha256 'c82c1ee90810db5ccd725f7d0d68b42aa6db9a1c8bf6fe2a4dd0ca91a271aa7f'

  head 'https://github.com/openlink/virtuoso-opensource.git', :branch => 'develop/6'

  # If gawk isn't found, make fails deep into the process.
  depends_on 'gawk' => :build

  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  skip_clean :la

  def patches
    # hotfix for https://github.com/openlink/virtuoso-opensource/issues/68
    # should be applied only to 6.1.7 — remove when building newer versions
    "https://github.com/openlink/virtuoso-opensource/commit/fd538a973b773443323939544b018a40ce4c8fee.patch"
  end if build.stable?

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
