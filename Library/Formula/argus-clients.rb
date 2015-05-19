require "formula"

class ArgusClients < Formula
  desc "Audit Record Generation and Utilization System clients"
  homepage "http://qosient.com/argus/"
  url "http://qosient.com/argus/src/argus-clients-3.0.8.tar.gz"
  sha1 "3b9d764dc067af64670bcd8328d6f48088b9b5ca"

  bottle do
    cellar :any
    sha1 "fd64dab110eaa36c7722c547faa2baaed55684de" => :yosemite
    sha1 "b3d61df656a92a74cfd57a0230ffe010a5ebc0f8" => :mavericks
    sha1 "9e8d00a518618556b804803b46777fde95ec10d7" => :mountain_lion
  end

  depends_on "readline" => :recommended
  depends_on "rrdtool" => :recommended

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
