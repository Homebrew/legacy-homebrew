require 'formula'

class Hamsterdb < Formula

  homepage 'http://hamsterdb.com'
  url 'http://hamsterdb.com/dl/hamsterdb-2.1.2.tar.gz'
  sha256 '5d1adbd25aad38646c83b8db013dc02af563c2447bd79b25aeac6cc287d098b0'

  head 'https://github.com/cruppstahl/hamsterdb.git', :branch => 'topic/next'

  option 'without-java', 'Do not build the Java wrapper'
  option 'without-remote', 'Disable access to remote databases'

  depends_on 'boost'
  depends_on 'gnutls'

  if build.with? 'remote'
    depends_on 'protobuf'
    depends_on 'libuv'
  end

  if build.head?
    depends_on 'libtool' => :build
    depends_on 'automake' => :build
  end

  def install

    if build.head?
      inreplace 'bootstrap.sh', /^libtoolize/, 'glibtoolize'
      system "./bootstrap.sh"
    end

    features = []
    features << '--disable-java' if build.without? 'java'
    features << '--disable-remote' if build.without? 'remote'

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", *features

    system "make", "install"

  end

  test do
    system "ham_info -h"
    system "hamzilla -h" if File.file? "#{HOMEBREW_PREFIX}/bin/hamzilla"
  end

end
