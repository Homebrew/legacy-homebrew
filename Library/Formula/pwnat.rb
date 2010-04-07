require 'formula'

class Pwnat <Formula
  url 'http://samy.pl/pwnat/pwnat-0.2-beta.tgz'
  homepage 'http://samy.pl/pwnat/'
  md5 '55e2109e5237927336dfe128718097d7'
  version '0.2-beta'

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "CC", ENV.cc
      s.change_make_var! "CFLAGS", ENV['CFLAGS']
      s.change_make_var! "LDFLAGS", "-lz"
    end

    system "make"
    bin.install "pwnat"
  end
end
