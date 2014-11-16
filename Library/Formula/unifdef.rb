require "formula"

class Unifdef < Formula
  homepage "http://dotat.at/prog/unifdef/"
  head "https://github.com/fanf2/unifdef.git"
  url "http://dotat.at/prog/unifdef/unifdef-2.10.tar.gz"
  sha1 "8bc4e4feb914ff4aa164b23230b51d3f526559ac"

  keg_only :provided_by_osx,
    "The unifdef provided by Xcode cannot compile gevent."

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "echo '' | #{bin}/unifdef"
  end
end
