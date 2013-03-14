require 'formula'

class TeeClc < Formula
  homepage 'http://www.microsoft.com/en-us/download/details.aspx?id=4240'
  url 'http://download.microsoft.com/download/4/2/7/427AC2CF-8A5B-4DE9-8221-22F54B1903E2/TEE-CLC-11.0.0.1212.zip'
  sha1 '1f16ac62ab64cfbd88ad471ea3d21a62d5eb78e6'

  def install
    if build.stable?
      install_prefix = ''
    else
      system 'mvn', 'assembly:assembly'
      system 'unzip', Dir['target/tf-*.zip'], "-dtarget"
      install_prefix = Dir['target/tf-*/'].to_s
    end

    libexec.install install_prefix + 'tf'
    libexec.install install_prefix + 'lib'
    (libexec + "native").install install_prefix + 'native/macosx'

    bin.write_exec_script libexec/'tf'
    share.install 'help'
  end

  def test
    system "mvn", "test" unless build.stable?
    system "#{bin}/tf"
  end
end
