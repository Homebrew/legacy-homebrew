require 'formula'

class Nimrod < Formula
  homepage 'http://nimrod-code.org/'
  url 'http://nimrod-code.org/download/nimrod_0.9.2.zip'
  sha1 '326ecd61d6df45afdc04cb8685ef46f8fb8f9e47'

  head 'https://github.com/Araq/Nimrod.git'

  # Install to libexec until an upstream fix appears for
  # https://github.com/Araq/Nimrod/issues/459
  def install
    system "/bin/sh", "./build.sh"
    inreplace 'install.sh', '$1/nimrod', '$1'
    system "/bin/sh", "./install.sh", libexec
  end

  test do
    (testpath/'hello.nim').write <<-EOS.undent
      echo("Hi!")
    EOS
    system "#{libexec}/bin/nimrod", "compile", "--run", "hello.nim"
  end

  def caveats; <<-EOS.undent
    Nimrod has been installed to #{libexec}.
    The compiler will currently fail to find system.nim if called through a
    symlink. To compile nim files, specify the full path to the compiler:

      #{libexec}/bin/nimrod compile --run hello.nim
    EOS
  end
end
