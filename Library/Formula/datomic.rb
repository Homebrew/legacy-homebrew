class Datomic < Formula
  desc "Database separating transactions, storage and queries"
  homepage "http://www.datomic.com/"
  url "https://my.datomic.com/downloads/free/0.9.5344"
  version "0.9.5344"
  sha256 "7fa7d09b2aeae8f2a189f09a8b09c485cdee202e00aacc80c213d25735030498"

  bottle :unneeded

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
    IO.popen("#{bin}/datomic-repl", "r+") do |pipe|
      assert_equal "Clojure 1.7.0", pipe.gets.chomp
      pipe.puts "^C"
      pipe.close_write
      pipe.close
    end
  end
end
