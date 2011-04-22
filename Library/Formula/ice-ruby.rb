require 'formula'

class IceRuby < Formula
  url 'http://www.zeroc.com/download/Ice/3.4/Ice-3.4.1.tar.gz'
  homepage 'http://www.zeroc.com'
  md5 '3aae42aa47dec74bb258c1a1b2847a1a'

  depends_on 'ice'

  def install
    ENV.O2
    inreplace "rb/config/Make.rules" do |s|
      s.gsub! "#OPTIMIZE", "OPTIMIZE"
      s.gsub! "/opt/Ice-$(VERSION)", "#{prefix}"
      s.gsub! "/opt/Ice-$(VERSION_MAJOR).$(VERSION_MINOR)", "#{prefix}"
    end

    Dir.chdir "rb" do
      system "make"
      system "make install"
    end

  end
end
