class Log4shib < Formula
  desc "Forked version of log4cpp for the Shibboleth project"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/log4shib"
  url "https://shibboleth.net/downloads/log4shib/1.0.9/log4shib-1.0.9.tar.gz"
  sha256 "b34cc90f50962cc245a238b472f72852732d32a9caf9a10e0244d0e70a311d6d"

  bottle do
    cellar :any
    sha256 "4bc1071029e6c9cb46d8ab05079ae9d8dc148df73009db99c4e94dfaab74fe4c" => :yosemite
    sha256 "0d3d2c95cac3b915a3278ea14550eaedd8e12aea205d7833a7266f4121e56a45" => :mavericks
    sha256 "3a5c7a68ba63d929fec53b79f6df2aa79fad75771d33d28b072ffaa49dd49956" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_equal "-L#{HOMEBREW_PREFIX}/Cellar/log4shib/1.0.9/lib -llog4shib",
                 shell_output("#{bin}/log4shib-config --libs").chomp
  end
end
