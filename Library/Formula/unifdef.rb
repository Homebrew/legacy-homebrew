require 'formula'

class Unifdef < Formula
  homepage 'http://dotat.at/prog/unifdef/'
  url 'http://dotat.at/prog/unifdef/unifdef-2.6.tar.gz'
  sha1 '1b9bea1c4abc2c8fa3f90d6340200f9bd6ead6d9'

  keg_only :provided_by_osx,
    "The unifdef provided by Xcode cannot compile gevent."

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  def test
    system "echo '' | #{bin}/unifdef"
  end
end
