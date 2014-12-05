require "formula"

class Nimble < Formula
  homepage "https://github.com/nimrod-code/nimble"
  head "https://github.com/nimrod-code/nimble.git"

  depends_on "nimrod"

  resource "nimble-wrapper" do
    url "https://github.com/philip-wernersbach/nimble-wrapper.git"
  end

  def install
    cd ".." do
      mkdir prefix/"nimble_wrapper"

      mv buildpath, prefix/"nimble_wrapper/nimble"
      mkdir buildpath
    end

    resource("nimble-wrapper").stage do
      system "nimrod", "c", "-r", "install", prefix/"nimble_wrapper"
    end

    bin.install_symlink prefix/"nimble_wrapper/bin/nimble"
  end

  test do
    system "#{bin}/nimble", "--version"
  end

  def caveats; <<-EOS.undent
    nimble"s bin directory can be included in $PATH for easier access to
    executables installed by nimble packages:
      ~/.babel/bin
    EOS
  end
end
