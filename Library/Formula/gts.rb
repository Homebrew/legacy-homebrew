require 'formula'

class Gts < Formula
  homepage 'http://gts.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/gts/gts/0.7.6/gts-0.7.6.tar.gz'
  sha1 '000720bebecf0b153eb28260bd30fbd979dcc040'

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"
  end
end
