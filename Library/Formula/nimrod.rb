require 'formula'

class Nimrod < Formula
  homepage 'http://nimrod-code.org/'
  url 'http://nimrod-code.org/download/nimrod_0.9.6.zip'
  sha1 'a0be99cd67ca2283c6cf076bb7edee74d2f32dc5'

  head 'https://github.com/Araq/Nimrod.git'

  def install
    system "/bin/sh", "./build.sh"
    inreplace 'install.sh', '$1/nimrod', '$1'
    system "/bin/sh", "./install.sh", prefix
  end

  test do
    (testpath/'hello.nim').write <<-EOS.undent
      echo("Hi!")
    EOS
    system "nimrod", "compile", "--run", "hello.nim"
  end
end
