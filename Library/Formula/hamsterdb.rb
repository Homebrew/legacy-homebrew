require 'formula'

class JavaRequirement < Requirement
  fatal true

  def self.jdk_home
    [
      `/usr/libexec/java_home`.chomp,
      ENV['JAVA_HOME']
    ].find { |dir| dir && File.exist?("#{dir}/bin/javac") && File.exist?("#{dir}/include") }
  end

  satisfy :build_env => false do
    self.class.jdk_home
  end

  def message; <<-EOS.undent
    Could not find a JDK (i.e. not a JRE)

    Do one of the following:
    - install a JDK that is detected with /usr/libexec/java_home
    - set the JAVA_HOME environment variable
    - specify --without-java
    EOS
  end
end

class Hamsterdb < Formula
  homepage 'http://hamsterdb.com'
  url "http://files.hamsterdb.com/dl/hamsterdb-2.1.7.tar.gz"
  sha1 "4ce5a0004e7f1fee28fcec0ee9c5478be5aad25c"

  option 'without-java', 'Do not build the Java wrapper'
  option 'without-remote', 'Disable access to remote databases'

  head do
    url 'https://github.com/cruppstahl/hamsterdb.git', :branch => 'topic/next'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  depends_on 'boost'
  depends_on 'gnutls'
  depends_on JavaRequirement if build.with? 'java'

  if build.with? 'remote'
    depends_on 'protobuf'
    depends_on 'libuv'
  end

  def install
    system '/bin/sh', 'bootstrap.sh' if build.head?

    features = []
    features << '--disable-remote' if build.without? 'remote'

    if build.with? 'java'
      features << "JDK=#{JavaRequirement.jdk_home}"
    else
      features << '--disable-java'
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          *features
    system "make", "install"
  end

  test do
    system "#{bin}/ham_info -h"
  end
end
