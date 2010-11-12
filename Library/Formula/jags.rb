require 'formula'

class Jags <Formula
  url 'http://sourceforge.net/projects/mcmc-jags/files/JAGS/2.x/Source/JAGS-2.1.0.tar.gz'
  homepage 'http://www-fis.iarc.fr/~martyn/software/jags/'
  md5 'ddb5eb745cb48537517aba186d7030c8'
  version '2.1'

  def install
    ENV['CFLAGS']="-mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -arch i386 -arch x86_64"
    ENV['CXXFLAGS']="-mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -arch i386 -arch x86_64"
    ENV['FFLAGS']="-mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -arch i386 -arch x86_64"
    ENV['LDFLAGS']="-mmacosx-version-min=10.5 -isysroot /Developer/SDKs/MacOSX10.5.sdk -arch i386 -arch x86_64"

    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
