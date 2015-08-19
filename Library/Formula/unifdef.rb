class Unifdef < Formula
  desc "Selectively process conditional C preprocessor directives"
  homepage "http://dotat.at/prog/unifdef/"
  head "https://github.com/fanf2/unifdef.git"
  url "http://dotat.at/prog/unifdef/unifdef-2.10.tar.gz"
  sha256 "1375528c8983de06bbf074b6cfa60fcf0257ea8efcbaec0953b744d2e3dcc5dd"

  keg_only :provided_by_osx,
    "The unifdef provided by Xcode cannot compile gevent."

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "echo '' | #{bin}/unifdef"
  end
end
