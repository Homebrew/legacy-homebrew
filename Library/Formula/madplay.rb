require 'formula'

class Madplay <Formula
  url 'http://downloads.sourceforge.net/project/mad/madplay/0.15.2b/madplay-0.15.2b.tar.gz'
  md5 '6814b47ceaa99880c754c5195aa1aac1'

  def homepage
    Formula.factory('mad').homepage
  end

  depends_on 'mad'
  depends_on 'libid3tag'

  def patches
    {:p0 => "http://svn.macports.org/repository/macports/trunk/dports/audio/madplay/files/patch-audio_carbon.c"}
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
