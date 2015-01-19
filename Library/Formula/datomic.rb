class Datomic < Formula
  homepage "http://www.datomic.com/"
  url "https://my.datomic.com/downloads/free/0.9.5130"
  sha256 "3fd1d7a8a2c400f570899e6bb77af246ea7d7561f7692b84f299064b8b22b681"
  version "0.9.5130"

  def write_libexec_alias(*script_names)
    base = "datomic"
    script_names.each do |script_name|
      alias_name = script_name == base ? base : "#{base}-#{script_name}"
      (bin + alias_name).write <<-EOS.undent
        #!/bin/bash
        cd #{libexec} && exec "bin/#{script_name}" "$@"
      EOS
    end
  end

  def install
    libexec.install Dir["*"]
    binaries = %w[datomic transactor repl repl-jline rest shell]
    write_libexec_alias(*binaries)
  end

  def caveats
    <<-EOS.undent
      You may need to set JAVA_HOME:
        export JAVA_HOME="$(/usr/libexec/java_home)"
      All commands have been installed with the prefix "datomic-".

      We agreed to the Datomic Free Edition License for you:
        http://www.datomic.com/datomic-free-edition-license.html
      If this is unacceptable you should uninstall.
    EOS
  end

  test do
    ENV["JAVA_HOME"] = `/usr/libexec/java_home`.strip

    help = pipe_output("#{bin}/datomic-shell", "Shell.help();\n")
    assert_match(/^\* Basics/, help)
  end
end
