require 'formula'

class Sleuthkit < Formula
  homepage 'http://www.sleuthkit.org/'
  url 'http://downloads.sourceforge.net/project/sleuthkit/sleuthkit/4.1.2/sleuthkit-4.1.2.tar.gz'
  sha1 'e44af40a934abeb6ce577f9ba71c86f11b80a559'

  head do
    url 'https://github.com/sleuthkit/sleuthkit.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  option 'with-jni', "Build Sleuthkit with JNI bindings"

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
