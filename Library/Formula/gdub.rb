require "formula"

class Gdub < Formula
  homepage "http://gdub.rocks"
  url "https://github.com/dougborg/gdub/archive/v0.1.0.tar.gz"
  sha1 "70eb6ab09f2781d8e606d36007f56e6508933f5e"

  def install
    bin.install "bin/gw"
  end

  depends_on "gradle" => :recommended

  def caveats; <<-EOS.undent
    Installing gradle is suggested so you can initialize projects or use other
    gradle features outside the context of an existing project.

    To just install gdub, run 'brew install gdub --without-gradle'
    EOS
  end
end
