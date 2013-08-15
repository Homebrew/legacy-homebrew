require 'formula'

require 'stringio'
module ScriptDataReader
  # This module contains a method for extracting the contents of DATA from a
  # Ruby file other than the script containing the currently executing
  # function.  Many thanks to Glenn Jackman's Stackoverflow answer which
  # provided this code:
  #
  #   http://stackoverflow.com/questions/2156629/can-i-access-the-data-from-a-required-script-in-ruby/2157556#2157556
  def self.load(filename)
    data = StringIO.new
    File.open(filename) do |f|
      begin
        line = f.gets
      end until line.nil? or line.match(/^__END__$/)
      while line = f.gets
        data << line
      end
    end
    data.rewind
    data
  end
end

# otherwise we may unpack bottles
ENV['HOMEBREW_BUILD_FROM_SOURCE'] = '1'

# Need to tweak the Formula class slightly so that patching is option and `DATA`
# patches work correctly.
class Formula
  # Create a reference to the original Formula.patch method and then override
  # so that paching only happens if the user asks.
  alias do_patch patch
  def patch
    if ARGV.flag? '--patch'
      begin
        old_verbose = $VERBOSE
        $VERBOSE = nil
        Formula.const_set 'DATA', ScriptDataReader.load(path)
      ensure
        $VERBOSE = old_verbose
      end

      do_patch
    end
  end

  # handle_llvm_failure() requires extend/ENV, so let's never fail
  # with llvm since we don't particularly care in this context.
  def fails_with_llvm?; false; end
end

module Homebrew extend self
  def unpack
    unpack_usage = <<-EOS
Usage: brew unpack [-pg] [--destdir=path/to/extract/in] <formulae ...>

Unpack formulae source code for inspection.

Formulae archives will be extracted to subfolders inside the current working
directory or a directory specified by `--destdir`. If the `-p` option is
supplied, patches will also be downloaded and applied. If the `-g` option is
specified a git repository is created and all files added so that you can diff
changes.
    EOS

    abort unpack_usage if ARGV.empty?

    formulae = ARGV.formulae
    raise FormulaUnspecifiedError if formulae.empty?

    unpack_dir = ARGV.options_only.select {|o| o.start_with? "--destdir="}
    if unpack_dir.empty?
      unpack_dir = Pathname.new Dir.getwd
    else
      unpack_dir = Pathname.new(unpack_dir.first.split('=')[1]).realpath
      unpack_dir.mkpath unless unpack_dir.exist?
    end

    raise "Cannot write to #{unpack_dir}" unless unpack_dir.writable_real?

    formulae.each do |f|
      # Create a nice name for the stage folder.
      stage_dir = unpack_dir + [f.name, f.version].join('-')

      if stage_dir.exist?
        raise "Destination #{stage_dir} already exists!" unless ARGV.force?
        rm_rf stage_dir
      end

      oh1 "Unpacking #{f.name} to: #{stage_dir}"
      ENV['VERBOSE'] = '1' # show messages about tar
      f.brew do
        cd Dir['*'][0] if Dir['*'].one?
        cp_r getwd, stage_dir
      end
      ENV['VERBOSE'] = nil

      if ARGV.switch? 'g'
        ohai "Setting up git repository"
        cd stage_dir
        system "git init -q"
        system "git add -A"
        system 'git commit -qm"Vanilla"'
      end
    end
  end
end

# Here is the actual code that gets run when `brew` loads this external
# command.
Homebrew.unpack
