require 'formula'

class Pwnat <Formula
  url 'http://samy.pl/pwnat/pwnat-0.1-beta.tgz'
  homepage 'http://samy.pl/pwnat/'
  md5 'c0cf6e02c6497a0b8ae5f541a8a1e3d5'
  version '0.1-beta'

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
