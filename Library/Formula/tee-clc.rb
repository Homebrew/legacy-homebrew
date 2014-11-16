require 'formula'

class TeeClc < Formula
  homepage 'http://www.microsoft.com/en-us/download/details.aspx?id=4240'
  url 'http://download.microsoft.com/download/4/2/7/427AC2CF-8A5B-4DE9-8221-22F54B1903E2/TEE-CLC-11.0.0.1212.zip'
  sha1 '1f16ac62ab64cfbd88ad471ea3d21a62d5eb78e6'

  conflicts_with 'tiny-fugue', :because => 'both install a `tf` binary'

  def install
    libexec.install "tf", "lib"
    (libexec/"native").install "native/macosx"
    bin.write_exec_script libexec/"tf"
    share.install "help"
  end

  test do
    system "#{bin}/tf"
  end
end
