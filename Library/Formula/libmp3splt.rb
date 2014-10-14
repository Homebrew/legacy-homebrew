require 'formula'

class Libmp3splt < Formula
  homepage 'http://mp3splt.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.8.2/libmp3splt-0.8.2.tar.gz'
  sha1 '5c8539391e26d047c30360b1dde2c08e6a02061f'

  bottle do
    sha1 "cd939c062ad24486c1414236ed8501b9fc5307de" => :mavericks
    sha1 "2ea059a18c4bcfc9bfbed32874ad60e363b908e1" => :mountain_lion
    sha1 "bab1bccca90ffc78f535dc469713267f9eb462cb" => :lion
  end

  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'pcre'
  depends_on 'libid3tag'
  depends_on 'mad'
  depends_on 'libvorbis'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
