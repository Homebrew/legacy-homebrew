require 'formula'

class Sleuthkit < Formula
  homepage 'http://www.sleuthkit.org/'
  url 'http://downloads.sourceforge.net/project/sleuthkit/sleuthkit/4.1.0/sleuthkit-4.1.0.tar.gz'
  sha1 '0622173bd4f20bc83cbea4e20e7db4c5b2d6c9c1'

  head 'https://github.com/sleuthkit/sleuthkit.git'

  option 'with-jni', "Build Sleuthkit with JNI bindings"

  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'afflib' => :optional
  depends_on 'libewf' => :optional

  conflicts_with 'ffind',
    :because => "both install a 'ffind' executable."

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"

    if build.with? 'jni'
      cd 'bindings/java' do
        system 'ant'
      end
      prefix.install 'bindings'
    end
  end
end
