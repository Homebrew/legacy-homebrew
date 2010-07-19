require 'formula'

class EyeD3 <Formula
  url 'http://eyed3.nicfit.net/releases/eyeD3-0.6.17.tar.gz'
  homepage 'http://eyed3.nicfit.net/'
  md5 '7bc175d0eb1e0152753b2aca80df6fde'

  aka "eyeD3"

  def install
    man1.install "doc/eyeD3.1.in" => "eyeD3.1"
    libexec.install "src/eyeD3"
    libexec.install "bin/eyeD3" => "eyeD3_script"
    bin.mkpath
    ln_s libexec+"eyeD3_script", bin+"eyeD3"
  end
end
