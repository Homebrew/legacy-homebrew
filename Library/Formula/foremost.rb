require 'formula'

class Foremost < Formula
  desc "Console program to recover files based on their headers and footers"
  homepage 'http://foremost.sourceforge.net/'
  url 'http://foremost.sourceforge.net/pkg/foremost-1.5.7.tar.gz'
  sha1 'c26d68990d7bd5245d5f7dc83c9217642a7a2056'

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr/", "#{prefix}/"
      s.change_make_var! "RAW_CC", ENV.cc
      s.change_make_var! "RAW_FLAGS", ENV.cflags
    end

    system "make mac"

    bin.install "foremost"
    man8.install "foremost.8.gz"
    etc.install "foremost.conf" => "foremost.conf.default"
  end
end
