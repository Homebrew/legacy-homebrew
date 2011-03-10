require 'formula'

class Ocrad < Formula
  url 'http://ftp.gnu.org/gnu/ocrad/ocrad-0.20.tar.gz'
  homepage 'http://www.gnu.org/software/ocrad/'
  md5 '47040630580dbc75ce16f4a4fabede3f'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"

    inreplace "Makefile" do |s|
      s.change_make_var! "CPPFLAGS", ENV['CPPFLAGS']
      s.change_make_var! "CXXFLAGS", ENV['CXXFLAGS']
    end

    system "make install"
  end
end
