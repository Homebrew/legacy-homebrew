require "formula"

class Iperf3 < Formula
  homepage "https://github.com/esnet/iperf"

  stable do
    url "https://github.com/esnet/iperf/archive/3.0.9.tar.gz"
    sha256 "985d87e2bc3f302dd5e864022f61b053cdeafd2e6a325711a317ed6aa1b68771"

    # Remove this with next stable release please! Fixed in HEAD.
    depends_on MaximumMacOSRequirement => :mavericks
  end

  head do
    url "https://github.com/esnet/iperf.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  bottle do
    cellar :any
    sha1 "32203dbcebb819a713d4e49fffc0b8e20bbec0ae" => :mavericks
    sha1 "9be1ed65f8e43db6fd9d8c15cb0248d74a1a0459" => :mountain_lion
    sha1 "92b9c81eba28fa0549c45d81162bc58561016163" => :lion
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "clean"      # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    system "#{bin}/iperf3", "--version"
  end
end
