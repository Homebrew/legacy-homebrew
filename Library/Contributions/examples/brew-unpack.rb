require 'formula'

module Homebrew extend self
  def unpack
    unpack_usage = <<-EOS
Usage: brew unpack [--destdir=path/to/extract/in] <formulae ...>

Unpack formulae source code for inspection.

Formulae archives will be extracted to subfolders inside the current working
directory or a directory specified by `--destdir`.
    EOS

    if ARGV.empty?
      puts unpack_usage
      exit 0
    end

    formulae = ARGV.named
    raise FormulaUnspecifiedError if formulae.empty?

    unpack_dir = ARGV.options_only.select {|o| o.start_with? "--destdir="}
    if unpack_dir.empty?
      unpack_dir = Pathname.new Dir.getwd
    else
      unpack_dir = Pathname.new(unpack_dir.first.split('=')[1]).realpath
      unpack_dir.mkpath unless unpack_dir.exist?
    end
    raise "Cannot write to #{unpack_dir}" unless unpack_dir.writable?

    formulae.each do |f|
      f = Formula.factory(f)

      unless f.downloader.kind_of? CurlDownloadStrategy
        stage_dir = unpack_dir + [f.name, f.version].join('-')
        stage_dir.mkpath unless stage_dir.exist?
      else
        stage_dir = unpack_dir
      end

      # Can't use a do block here without DownloadStrategy do blocks throwing:
      #   warning: conflicting chdir during another chdir block
      Dir.chdir stage_dir
        f.downloader.fetch
        f.downloader.stage
      Dir.chdir unpack_dir
    end
  end
end

# Here is the actual code that gets run when `brew` loads this external
# command.
Homebrew.unpack
