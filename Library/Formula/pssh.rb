require 'formula'

class Pssh < Formula
  homepage 'https://code.google.com/p/parallel-ssh/'
  url 'https://parallel-ssh.googlecode.com/files/pssh-2.3.1.tar.gz'
  sha1 '65736354baaa289cffdf374eb2ffd9aa1eda7d85'

  depends_on :python

  # TODO: Move this into Library/Homebrew somewhere (see also mitmproxy.rb and ansible.rb).
  def wrap bin_file, pythonpath
    bin_file = Pathname.new bin_file
    libexec_bin = Pathname.new libexec/'bin'
    libexec_bin.mkpath
    mv bin_file, libexec_bin
    bin_file.write <<-EOS.undent
    #!/bin/sh
    PYTHONPATH="#{pythonpath}:$PYTHONPATH" exec "#{libexec_bin}/#{bin_file.basename}" "$@"
    EOS
  end

  def install
    python do
      system python, "setup.py", "install",
        "--prefix=#{prefix}", "--install-data=#{share}"
    end

    Dir["#{bin}/*"].each do |bin_file|
      wrap bin_file, python.global_site_packages
    end
  end

  test do
    system "#{bin}/pssh", "--version"
  end
end
