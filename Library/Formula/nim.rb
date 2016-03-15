class Nim < Formula
  desc "Statically typed, imperative programming language"
  homepage "http://nim-lang.org/"
  version "0.13"
  url "http://nim-lang.org/download/nim-0.13.0.tar.xz"
  sha256 "cd61f5e5768d4063596d6df578ae9bb5f9d52430773542987e91050b848cb1a9"
  head "https://github.com/Araq/Nim.git", :branch => "devel"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a5c730b9a13b095a1ffbab95079ecd5c1c04a0fe01c1ee53289ac73af905b6a" => :el_capitan
    sha256 "e707da286aeadd48b85b9021f16c3b9831850f8806e297c1e40df2b68c777e20" => :yosemite
    sha256 "70c7a262d12c1ae48185061131794aa257726846c808e0d388a0fd3d8f416dc6" => :mavericks
  end

  def install
    if build.head?
      system "/bin/sh", "bootstrap.sh"
    else
      system "/bin/sh", "build.sh"
    end
    system "/bin/sh", "install.sh", prefix

    # Nim doesn't look for a config file in /usr/local, hence we need to make
    # sure to always pass the exact location of the path

    wrapping_script = bin + "nim"

    wrapping_script.write <<-EOS.undent
      #!/bin/bash

      # Actual path of the nim compiler
      nim="#{prefix}/nim/bin/nim"

      if [ -z "$1" ]; then
        # There were no args
        exec "$nim"
      else
        # Take the first arg, the command and then append the path
        command="$1"
        shift
        exec "$nim" $command --path:"#{prefix}/nim/lib" $@
      fi
    EOS

    wrapping_script.chmod 0755

    # Alias nimrod to the nim wrapping script
    bin.install_symlink wrapping_script => "nimrod"
  end

  test do
    (testpath/"hello.nim").write <<-EOS.undent
      echo("hello")
    EOS
    assert_equal "hello", shell_output("#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim").chomp
  end
end
