class Unifdef < Formula
  desc "Selectively process conditional C preprocessor directives"
  homepage "http://dotat.at/prog/unifdef/"
  url "http://dotat.at/prog/unifdef/unifdef-2.11.tar.gz"
  sha256 "e8483c05857a10cf2d5e45b9e8af867d95991fab0f9d3d8984840b810e132d98"
  head "https://github.com/fanf2/unifdef.git"

  keg_only :provided_by_osx,
    "The unifdef provided by Xcode cannot compile gevent."

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    pipe_output("#{bin}/unifdef", "echo ''")
  end
end
