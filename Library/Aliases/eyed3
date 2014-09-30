require 'formula'

class EyeD3 < Formula
  homepage 'http://eyed3.nicfit.net/'
  url 'http://eyed3.nicfit.net/releases/eyeD3-0.6.18.tar.gz'
  sha1 'd8887f7b75306bd293e0b0d46a977e73225ae7b5'

  def install
    man1.install "doc/eyeD3.1.in" => "eyeD3.1"

    # Manually process this file
    inreplace "src/eyeD3/__init__.py.in" do |s|
      s.change_make_var! "eyeD3Version", "\"#{version}\""
      s.change_make_var! "eyeD3Maintainer", "\"Packaged by Homebrew\""
    end
    mv "src/eyeD3/__init__.py.in", "src/eyeD3/__init__.py"

    libexec.install "src/eyeD3"
    libexec.install "bin/eyeD3" => "eyeD3_script"
    bin.install_symlink libexec+"eyeD3_script" => "eyeD3"
  end
end
