require 'formula'

class EyeD3 < Formula
  url 'http://eyed3.nicfit.net/releases/eyeD3-0.6.17.tar.gz'
  homepage 'http://eyed3.nicfit.net/'
  md5 '7bc175d0eb1e0152753b2aca80df6fde'

  def install
    man1.install "doc/eyeD3.1.in" => "eyeD3.1"

    # Manually process this file
    inreplace "src/eyeD3/__init__.py.in" do |s|
      s.change_make_var! "eyeD3Version", "\"#{version}\""
      s.change_make_var! "eyeD3Maintainer", "\"Pacakaged by Homebrew\""
    end
    mv "src/eyeD3/__init__.py.in", "src/eyeD3/__init__.py"

    libexec.install "src/eyeD3"
    libexec.install "bin/eyeD3" => "eyeD3_script"
    bin.mkpath
    ln_s libexec+"eyeD3_script", bin+"eyeD3"
  end
end
