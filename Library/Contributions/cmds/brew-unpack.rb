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

# Need to tweak the Formula class slightly so that patching is option and `DATA`
# patches work correctly.
class Formula
  # Create a reference to the original Formula.patch method and then override
  # so that paching only happens if the user asks.
  alias do_patch patch
  def patch
    if ARGV.include? '--patch'
      # Yes Ruby, we are about to redefine a constant. Just breathe.
      orig_v = $VERBOSE; $VERBOSE = nil
      Formula.const_set 'DATA', ScriptDataReader.load(path)
      $VERBOSE = orig_v

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
Usage: brew unpack [--patch] [--destdir=path/to/extract/in] <formulae ...>

Unpack formulae source code for inspection.

Formulae archives will be extracted to subfolders inside the current working
directory or a directory specified by `--destdir`. If the `--patch` option is
supplied, patches will also be downloaded and applied.
    EOS

    if ARGV.empty?
      puts unpack_usage
      exit 0
    end

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
      raise "Destination #{stage_dir} allready exists!" if stage_dir.exist?

      f.brew do
        oh1 "Unpacking #{f.name} to: #{stage_dir}"
        cp_r Dir.getwd, stage_dir
      end
    end
  end
end

# Here is the actual code that gets run when `brew` loads this external
# command.
Homebrew.unpack
