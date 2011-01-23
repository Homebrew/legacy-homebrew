require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpDba <BundledPhpExtensionFormula
  homepage 'http://php.net/dba'

  depends_on 'gdbm' if ARGV.include? "--gdbm"
  depends_on 'qdbm' if ARGV.include? "--qdbm"

  def options
    [
      ['--gdbm', 'Enable gdbm support.'],
      ['--qdbm', 'Enable qdbm support.']
    ]
  end

  def install
    args = []
    if ARGV.include? "--gdbm"
      args << "--with-gdbm=#{HOMEBREW_PREFIX}"
    end
    if ARGV.include? "--qdbm"
      args << "--with-qdbm=#{HOMEBREW_PREFIX}"
    end
    @configure_args = args
    super
  end
end
