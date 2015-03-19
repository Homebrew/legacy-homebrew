class Datomic < Formula
  homepage "http://www.datomic.com/"
  url "https://my.datomic.com/downloads/free/0.9.5130"
  sha256 "3fd1d7a8a2c400f570899e6bb77af246ea7d7561f7692b84f299064b8b22b681"
  version "0.9.5130"

  depends_on :java

  def install
    libexec.install Dir["*"]
    (bin/"datomic").write_env_script libexec/"bin/datomic", Language::Java.java_home_env
    %w[transactor repl repl-jline rest shell].each do |file|
      (bin/"datomic-#{file}").write_env_script libexec/"bin/#{file}", Language::Java.java_home_env
    end
  end

  def caveats
    <<-EOS.undent
      All commands have been installed with the prefix "datomic-".

      We agreed to the Datomic Free Edition License for you:
        http://www.datomic.com/datomic-free-edition-license.html
      If this is unacceptable you should uninstall.
    EOS
  end

  test do
    help = pipe_output("#{bin}/datomic-shell", "Shell.help();\n")
    assert_match(/^\* Basics/, help)
  end
end
