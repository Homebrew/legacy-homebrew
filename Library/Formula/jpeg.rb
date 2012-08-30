require 'formula'

class Jpeg < Formula
  url 'http://www.ijg.org/files/jpegsrc.v8d.tar.gz'
  sha1 'f080b2fffc7581f7d19b968092ba9ebc234556ff'
  homepage 'http://www.ijg.org'
  version '8d'

  bottle do
    sha1 '80b23581fb5b2b92d787969f75cedbe8054c93a4' => :mountainlion
    sha1 'a16984c6522807644ea960cb724f91aeca2d3dd0' => :lion
    sha1 'edff61d516f97d76341a14211d0206bda18d0cf7' => :snowleopard
  end

  def install
    ENV.universal_binary   # Builds universal libs. Default is static & shared.
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
