require "formula"

class Kvazaar < Formula
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/v0.2.4.tar.gz"
  sha1 "636c26955b0b69249f51bc8661a8d57ad4c581df"

  depends_on 'yasm' => :build

  def install
    cd 'src' do
      system 'make'
    end
    bin.install 'src/kvazaar'
  end

  test do
    system "kvazaar 2>&1 | grep 'HEVC Encoder v. 0.2'"
  end
end
