require 'formula'

class Newt < Formula
  homepage 'https://fedorahosted.org/newt/'
  url 'https://fedorahosted.org/releases/n/e/newt/newt-0.52.15.tar.gz'
  sha1 'e067280e474eb327c62eaa306e2242adcf540ab2'

  option 'python', 'Enable Python Bindings'

  depends_on 'gettext'
  depends_on 'popt'
  depends_on 's-lang'

  def patches
    { :p0 => [ "https://trac.macports.org/export/106061/trunk/dports/devel/libnewt/files/patch-configure.ac.diff",
               "https://trac.macports.org/export/106061/trunk/dports/devel/libnewt/files/patch-Makefile.in.diff" ] }
  end

  def install
    args = ["--prefix=#{prefix}", "--without-tcl"]
    if build.include? 'python'
      args << "--with-python"
    else
      args << "--without-python"
    end
    system "./configure", *args
    system "make install"
  end

  def caveats
    s = ''
    if build.include? 'python'
      s += <<-EOS.undent
        Python bindings installed to:
          #{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages

        For non-homebrew Python, you need to amend your PYTHONPATH like so:
          export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
      EOS
    end
    return s.empty? ? nil : s
  end

  def which_python
    'python' + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
