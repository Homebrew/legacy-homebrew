require 'formula'

class Unifdef < Formula
  url 'http://dotat.at/prog/unifdef/unifdef-2.6.tar.gz'
  homepage 'http://dotat.at/prog/unifdef/'
  md5 '18b832baea2c7b6b00bd7d4f3db38f62'

  keg_only :provided_by_osx,
    "The unifdef provided by Xcode cannot compile gevent."

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  def test
    system "echo '' | #{bin}/unifdef"
  end
end
