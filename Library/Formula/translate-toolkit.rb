require "formula"

class TranslateToolkit < Formula
  homepage "http://toolkit.translatehouse.org/"
  url "https://downloads.sourceforge.net/project/translate/Translate%20Toolkit/1.12.0/translate-toolkit-1.12.0.tar.bz2"
  sha1 "76d3f33afb5ac723da05558cebe80642af31657a"

  def install
    minor = `python -c 'import sys; print(sys.version_info[1])'`.chomp

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.#{minor}/site-packages"
    system "python", "setup.py", "install",
             "--prefix=#{libexec}",
             "--install-scripts=#{bin}"
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end
end
