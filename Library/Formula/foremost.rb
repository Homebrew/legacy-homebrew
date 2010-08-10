require 'formula'

class Foremost <Formula
  url 'http://foremost.sourceforge.net/pkg/foremost-1.5.7.tar.gz'
  homepage 'http://foremost.sourceforge.net/'
  md5 '860119c49665c2a3fb2b0b1d3dbad02a'

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr/", "#{prefix}/"
      s.change_make_var! "RAW_CC", ENV.cc
      s.change_make_var! "RAW_FLAGS", ENV.cflags
    end

    system "make mac"

    bin.install "foremost"
    man8.install "foremost.8.gz"
    etc.install "foremost.conf" => "foremost.conf.sample"
  end
end
