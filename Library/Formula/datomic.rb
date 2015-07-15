class Datomic < Formula
  desc "Database that simplifies by separating transactions, storage and queries"
  homepage "http://www.datomic.com/"
  url "https://my.datomic.com/downloads/free/0.9.5198"
  sha256 "1d42979079bd62c2b4df9fbc3c18cdc15d49ac04905eceab4c75720e23ed8fc7"
  version "0.9.5198"

  depends_on :java

  def install
    libexec.install Dir["*"]
    (bin/"datomic").write_env_script libexec/"bin/datomic", Language::Java.java_home_env
    %w[transactor repl repl-jline rest shell groovysh maven-install].each do |file|
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
