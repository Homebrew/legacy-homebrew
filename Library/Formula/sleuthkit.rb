require 'formula'

class Sleuthkit < Formula
  homepage 'http://www.sleuthkit.org/'
  url 'https://downloads.sourceforge.net/project/sleuthkit/sleuthkit/4.1.3/sleuthkit-4.1.3.tar.gz'
  sha1 '9350bb59bb5fbe41d6e29a8d0494460b937749ef'

  head do
    url 'https://github.com/sleuthkit/sleuthkit.git'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  conflicts_with 'irods', :because => 'both install `ils`'

  option 'with-jni', "Build Sleuthkit with JNI bindings"

  depends_on :ant => :build
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
