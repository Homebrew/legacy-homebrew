require 'formula'

class Madplay < Formula
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
    configure_flags = ["--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"]
    # Avoid "error: CPU you selected does not support x86-64 instruction set"
    configure_flags << "--build=x86_64" if MacOS.prefer_64_bit?
    system "./configure", *configure_flags
    system "make install"
  end
end
