require 'formula'

class Hamsterdb < Formula
  homepage 'http://hamsterdb.com'
  url 'http://hamsterdb.com/dl/hamsterdb-2.1.2.tar.gz'
  sha256 '5d1adbd25aad38646c83b8db013dc02af563c2447bd79b25aeac6cc287d098b0'

  head do
    url 'https://github.com/cruppstahl/hamsterdb.git', :branch => 'topic/next'

    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  option 'without-java', 'Do not build the Java wrapper'
  option 'without-remote', 'Disable access to remote databases'

  depends_on 'boost'
  depends_on 'gnutls'

  if build.with? 'remote'
    depends_on 'protobuf'
    depends_on 'libuv'
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
                          "--prefix=#{prefix}",
                          *features
    system "make", "install"

  end

  test do
    system "#{bin}/ham_info -h"
  end
end
