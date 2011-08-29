require 'formula'

class Unifdef < Formula
  url 'http://dotat.at/prog/unifdef/unifdef-2.6.tar.gz'
  homepage 'http://dotat.at/prog/unifdef/'
  md5 '18b832baea2c7b6b00bd7d4f3db38f62'

  def install
    system "make prefix=#{prefix} install"
  end

  def test
    system "unifdef -V"
  end
end
