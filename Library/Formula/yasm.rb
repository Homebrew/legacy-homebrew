require 'formula'

class Yasm < Formula
  homepage 'http://yasm.tortall.net/'
  url 'http://tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz'
  sha256 '768ffab457b90a20a6d895c39749adb547c1b7cb5c108e84b151a838a23ccf31'
  head 'https://github.com/yasm/yasm.git'

  def options
    [
      ['--enable-python', 'Enable Python bindings support.']
    ]
  end

  depends_on 'gettext' if ARGV.build_head?
  depends_on 'Cython' => :python if ARGV.include? '--enable-python'

  def install
    args = ["--prefix=#{prefix}",
            "--disable-debug"]

    if ARGV.include? '--enable-python'
      args << '--enable-python'
      args << '--enable-python-bindings'
    end

    system './autogen.sh' if ARGV.build_head?
    system './configure', *args
    system 'make install'
  end

  def caveats
    if ARGV.include? '--enable-python' then <<-EOS.undent
      Python bindings installed to:
        #{lib}/#{which_python}/site-packages

      For non-homebrew Python, you need to amend your PYTHONPATH like so:
        export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
      EOS
    end
  end

  def which_python
    'python' + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
