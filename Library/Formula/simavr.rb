class Simavr < Formula
  desc "a lean, mean and hackable AVR simulator for linux & OSX "
  homepage "https://github.com/buserror/simavr"
  url "https://github.com/buserror/simavr/archive/v1.2.tar.gz"
  sha256 "c7f645b323d74247409b50ea6915f1f324a7ee2a799ef107613626801defc070"

  depends_on "osx-cross/avr/avr-gcc"
  depends_on "libelf"

  head do
    url "https://github.com/buserror/simavr.git"

    patch :p1 do
      url "https://patch-diff.githubusercontent.com/raw/buserror/simavr/pull/147.diff"
      sha256 "b2322ef7d1aee1f7564cc1cb6fcb92079680fda2ab7b4f0c3c74b6454649c982"
    end
  end

  def install
    ENV.append_path "PATH", "#{ENV["HOMEBREW_PREFIX"]}/bin"
    system "make", "install", "DESTDIR=#{prefix}", "RELEASE=1"
    prefix.install "examples"
  end
end
