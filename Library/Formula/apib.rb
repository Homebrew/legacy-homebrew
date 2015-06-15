class Apib < Formula
  desc "HTTP performance-testing tool"
  homepage "https://github.com/apigee/apib"
  url "https://github.com/apigee/apib/archive/APIB_1_0.tar.gz"
  sha256 "1592e55c01f2f9bc8085b39f09c49cd7b786b6fb6d02441ca665eef262e7b87e"
  revision 1

  head "https://github.com/apigee/apib.git"

  bottle do
    cellar :any
    sha1 "ffdea23d6f3e9627d3d99ec931d29f1e93f7dd9f" => :yosemite
    sha1 "d7443be34f3d7b9347c26bfdaae5c46eab41e3c8" => :mavericks
    sha1 "0952c22383ab1f4da194d66b823dd513a3f30ac8" => :mountain_lion
  end

  depends_on :apr => :build
  depends_on "openssl"

  def install
    # Upstream hardcodes finding apr in /usr/include. When CLT is not present
    # we need to fix this so our apr requirement works.
    # https://github.com/apigee/apib/issues/11
    unless MacOS::CLT.installed?
      inreplace "configure" do |s|
        s.gsub! "/usr/include/apr-1.0", "#{Formula["apr"].opt_prefix}/libexec/include/apr-1"
        s.gsub! "/usr/include/apr-1", "#{Formula["apr"].opt_prefix}/libexec/include/apr-1"
      end
      ENV.append "LDFLAGS", "-L#{Formula["apr-util"].opt_prefix}/libexec/lib"
      ENV.append "LDFLAGS", "-L#{Formula["apr"].opt_prefix}/libexec/lib"
      ENV.append "CFLAGS", "-I#{Formula["apr"].opt_prefix}/libexec/include/apr-1"
      ENV.append "CFLAGS", "-I#{Formula["apr-util"].opt_prefix}/libexec/include/apr-1"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "apib", "apibmon"
  end

  test do
    system "#{bin}/apib", "-c 1", "-d 1", "https://www.google.com"
  end
end
