require 'formula'

class Voldemort < Formula
  homepage 'http://project-voldemort.com/'
  url 'https://github.com/voldemort/voldemort/archive/v1.4.0.tar.gz'
  sha1 'f07b552d494b9b68d9c4e3561384bc932e7e7bd8'

  depends_on :ant => :build

  skip_clean 'libexec/config'

  def install
    system "ant"
    libexec.install %w(bin lib dist contrib)
    libexec.install "config" => "config-examples"
    (libexec/"config").mkpath

    # Write shim scripts for all utilities
    bin.write_exec_script Dir["#{libexec}/bin/*.sh"]
  end

  def caveats; <<-EOS.undent
    You will need to set VOLDEMORT_HOME to:
      #{libexec}

    Config files should be placed in:
      #{libexec}/config
    or you can set VOL_CONF_DIR to a more reasonable path.
    EOS
  end
end
