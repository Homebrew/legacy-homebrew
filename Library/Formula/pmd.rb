require 'formula'

class JdkInstalled < Requirement
  fatal true
  satisfy{ which 'javac' }
  def message; <<-EOS.undent
    A JDK is required.  You can get the official Oracle installers from:
    http://www.oracle.com/technetwork/java/javase/downloads/index.html
    EOS
  end
end

class JavaHome < Requirement
  fatal true
  satisfy { ENV["JAVA_HOME"] }
  def message; <<-EOS.undent
    JAVA_HOME is not set:  please set it to the correct value for your Java
    installation. For instance:
    /Library/Java/JavaVirtualMachines/jdk1.7.0_40.jdk/Contents/Home
    EOS
  end
end

class Pmd < Formula
  homepage ''
  url 'http://sourceforge.net/projects/pmd/files/pmd/5.0.5/pmd-bin-5.0.5.zip/download'
  sha1 '0f5368eda17e49bced5066340c1e57061406131a'

  depends_on JdkInstalled
  depends_on JavaHome

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
 
    libexec.install %w[bin etc lib LICENSE.txt]
    # add lib path to the run script
    insert_lines_following_line( "#{libexec}/bin/run.sh", 2 ) do |outf|
      outf.puts "LIB_DIR=\"#{libexec}/lib\""
      outf.puts ""
    end
    # fix permissions
    File.chmod(0755, "#{libexec}/bin/run.sh")

    bin.install_symlink "#{libexec}/bin/run.sh" => 'pmd'
  end

  test do
    system "pmd", "pmd"
  end

  def insert_lines_following_line file, line_no
    tmp_fn = "#{file}.tmp"
    File.open( tmp_fn, 'w' ) do |outf|
      line_ct = 0
      IO.foreach(file) do |line|
        outf.print line
        yield(outf) if line_no == (line_ct += 1)
      end
    end
    File.rename tmp_fn, file
  end
end
