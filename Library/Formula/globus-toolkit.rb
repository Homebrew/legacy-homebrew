class GlobusToolkit < Formula
  homepage "http://www.globus.org/toolkit/"
  # Note: Stable distributions have an even minor version number (e.g. 5.0.3)
  url "http://toolkit.globus.org/ftppub/gt6/installers/src/globus_toolkit-6.0.tar.gz"
  sha1 "cb688858f96b26a92d72efedc1153a8cbf2516b8"

  bottle do
    sha1 "b0a24a8d66dd36aa0ac48f0ae5dddfd02af22d6c" => :yosemite
    sha1 "a9e19f50eed7f13d0200c107aabe20751071bc9b" => :mavericks
    sha1 "1cbbe7a3d08711cbc5665e91558417d7b2028d3a" => :mountain_lion
  end

  depends_on "openssl"
  depends_on "libtool" => :run
  depends_on "pkg-config" => :build

  option "with-check", "Test the toolkit when installing"

  def install
    ENV.deparallelize
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    man.mkpath
    system "./configure", "--prefix=#{libexec}",
                          "--mandir=#{man}",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
    bins = Dir["#{libexec}/bin/*"].select { |f| File.executable? f }
    bin.write_exec_script bins
  end

  test do
    system "#{bin}/globusrun", "-help"
  end
end
