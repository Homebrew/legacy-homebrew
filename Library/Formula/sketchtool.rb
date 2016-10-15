require "formula"

class Sketchtool < Formula
  homepage "http://bohemiancoding.com/sketch/tool/"
  url "http://sketchtool.bohemiancoding.com/sketchtool-latest.zip"
  sha1 "1d727f3d2c245ef5858e41ce9bdc44676416d62b"

  def install
    bin.install "sketchtool"
    prefix.install "sketchtool resources.bundle"
    ln_s prefix/"sketchtool resources.bundle", "#{HOMEBREW_PREFIX}/bin/"
  end

  test do
    system "#{bin}/sketchtool"
  end
end
