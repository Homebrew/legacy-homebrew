require 'formula'

class Unifdef < Formula
  homepage 'http://dotat.at/prog/unifdef/'
  url 'https://github.com/fanf2/unifdef/archive/unifdef-2.10.tar.gz'
  sha1 'e732705d5c84e8b4f704369a9d3e387494ff6f19'
  head 'https://github.com/fanf2/unifdef.git'

  keg_only :provided_by_osx,
    "The unifdef provided by Xcode cannot compile gevent."

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "echo '' | #{bin}/unifdef"
  end
end
