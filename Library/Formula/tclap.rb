class Tclap < Formula
  desc "Templatized C++ command-line parser library"
  homepage "http://tclap.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/tclap/tclap-1.2.1.tar.gz"
  sha256 "9f9f0fe3719e8a89d79b6ca30cf2d16620fba3db5b9610f9b51dd2cd033deebb"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    # Installer scripts have problems with parallel make
    ENV.deparallelize
    system "make", "install"
  end
end
