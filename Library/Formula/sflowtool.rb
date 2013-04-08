require 'formula'

class Sflowtool < Formula
  homepage 'http://www.inmon.com/technology/sflowTools.php'
  url 'http://www.inmon.com/bin/sflowtool-3.27.tar.gz'
  sha1 '5205ef2df9cc0b1253765a27ea200446c4525642'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end

  test do
    require 'open3'
    Open3.popen3("#{bin}/sflowtool", "-h") do |_, _, stderr|
      /sflowtool version: #{Regexp.escape(version)}/ === stderr.read
    end
  end
end
