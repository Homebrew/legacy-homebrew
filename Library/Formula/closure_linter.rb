require 'formula'

class ClosureLinter < Formula
  homepage 'http://code.google.com/p/closure-linter/'
  url 'http://closure-linter.googlecode.com/files/closure_linter-2.3.5.tar.gz'
  md5 'af468081035cbe8b463f955e10b58dab'

  def install
    ENV.prepend 'PYTHONPATH', "#{libexec}", ':'
    libexec.mkdir
    system "python", "setup.py", "install",
                     "--prefix=#{prefix}",
                     "--install-purelib=#{libexec}",
                     "--install-platlib=#{libexec}",
                     "--install-scripts=#{bin}"
    site_packages = "#{lib}/#{which_python}/site-packages/"
    FileUtils.mkdir_p site_packages
    unless File.exists? "#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages/python_gflags-2.0-py2.7.egg"
      File.symlink libexec+'python_gflags-2.0-py2.7.egg', site_packages+'python_gflags-2.0-py2.7.egg'
    end
    File.symlink libexec+'closure_linter-2.3.5-py2.7.egg', site_packages+'closure_linter-2.3.5-py2.7.egg'
  end
  
  def caveats; <<-EOS.undent
    For non-homebrew Python, you need to amend your PYTHONPATH:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH

    Run the closure linter with 'gjslint' or 'fixjsstyle'
    EOS
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
