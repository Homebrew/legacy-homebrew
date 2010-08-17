require 'formula'

class Pwnat <Formula
  url 'http://samy.pl/pwnat/pwnat-0.3-beta.tgz'
  homepage 'http://samy.pl/pwnat/'
  md5 'd1f2b556a32669484f0358d009a20feb'
  version '0.3-beta'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "CC", ENV.cc
      s.change_make_var! "CFLAGS", ENV.cflags
      s.change_make_var! "LDFLAGS", "-lz"
    end

    system "make"
    bin.install "pwnat"
  end
end
