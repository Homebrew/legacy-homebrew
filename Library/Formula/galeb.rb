class Galeb < Formula
  homepage "http://galeb.io/"

  depends_on :java => "1.7+"
  depends_on "vert.x"

  head do
    url "https://github.com/globocom/galeb.git"
    depends_on "maven" => :build
  end

  # Writes an exec script that invokes a java jar with vertx
  def write_vertx_script target_jar, script_name, opts=""
    (bin+script_name).write <<-EOS.undent
      #!/bin/bash
      exec vertx runzip #{opts} #{target_jar} "$@"
    EOS
  end

  def install
    if not build.head?
      odie "galeb is currently a head-only formula."
    end

    # Build the package from source
    java_home = ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp
    system "mvn", "clean", "package", "-DskipTests"

    # Move libraries to `libexec` directory
    libexec.install Dir["galeb-router/target/*.jar"]
    write_vertx_script libexec/"galeb-router-2.0-SNAPSHOT.jar", "galeb"
  end
end
