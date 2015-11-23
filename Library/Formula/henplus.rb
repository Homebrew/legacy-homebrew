class Henplus < Formula
  desc "SQL shell that can handle multiple sessions in parallel"
  homepage "https://github.com/neurolabs/henplus"
  url "https://github.com/downloads/neurolabs/henplus/henplus-0.9.8.tar.gz"
  sha256 "ea7ca363d0503317235e97f66aa0efefe44463d8445e88b304ec0ac1748fe1ff"

  depends_on :ant => :build
  depends_on "libreadline-java"

  def install
    ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp

    inreplace "bin/henplus" do |s|
      s.gsub! "LD_LIBRARY_PATH", "DYLD_LIBRARY_PATH"
      s.change_make_var! "DYLD_LIBRARY_PATH", Formula["libreadline-java"].opt_lib
      s.gsub! "$THISDIR/..", HOMEBREW_PREFIX
      s.gsub! "share/java/libreadline-java.jar",
              "share/libreadline-java/libreadline-java.jar"
    end

    system "ant", "install", "-Dprefix=#{prefix}"
  end

  def caveats; <<-EOS.undent
    You may need to set JAVA_HOME:
      export JAVA_HOME="$(/usr/libexec/java_home)"
    EOS
  end

  test do
    system bin/"henplus", "--help"
  end
end
