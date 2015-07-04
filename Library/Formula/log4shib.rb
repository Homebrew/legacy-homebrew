class Log4shib < Formula
  desc "Forked version of log4cpp for the Shibboleth project"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/log4shib"
  url "http://shibboleth.net/downloads/log4shib/1.0.9/log4shib-1.0.9.tar.gz"
  sha256 "b34cc90f50962cc245a238b472f72852732d32a9caf9a10e0244d0e70a311d6d"

  bottle do
    cellar :any
    sha1 "52020be4054b860c4fb405195a7a903c761b2653" => :yosemite
    sha1 "35ee49ecba1bbce1384adf514e8e6fa379d08efd" => :mavericks
    sha1 "54d576f964483fc65e6cfe77085820eadc522830" => :mountain_lion
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
