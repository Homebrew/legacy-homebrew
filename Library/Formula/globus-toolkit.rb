class GlobusToolkit < Formula
  desc "Toolkit used for building grids"
  homepage "http://www.globus.org/toolkit/"
  # Note: Stable distributions have an even minor version number (e.g. 5.0.3)
  url "http://toolkit.globus.org/ftppub/gt6/installers/src/globus_toolkit-6.0.1443479657.tar.gz"
  sha256 "1aebd5599af535c5978bd085c5614f0f28cbd1fd724a53072a30e74a07597cc5"

  bottle do
    sha256 "bac29ffc13caffc83fc7862cc5d9e259ed63134680084959afe057dc97a36f50" => :el_capitan
    sha256 "091e8b213a1c6338ea1edf85a87c4bbecd8535887263441ac73e28759268861a" => :yosemite
    sha256 "3f7fed89fd07105e6ff59741c0d8d4449aebf4269d1fdb166d6b4ade077d3cdd" => :mavericks
  end

  option "with-test", "Test the toolkit when installing"
  deprecated_option "with-check" => "with-test"

  depends_on "openssl"
  depends_on "libtool" => :run
  depends_on "pkg-config" => :build

  def install
    ENV.deparallelize
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    man.mkpath
    system "./configure", "--prefix=#{libexec}",
                          "--mandir=#{man}",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
    bins = Dir["#{libexec}/bin/*"].select { |f| File.executable? f }
    bin.write_exec_script bins
  end

  test do
    system "#{bin}/globusrun", "-help"
  end
end
