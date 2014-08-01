require "stringio"
require "formula"

module Homebrew
  module UnpackPatch
    def patch
      super if ARGV.flag?("--patch")
    end
  end

  def unpack
    formulae = ARGV.formulae
    raise FormulaUnspecifiedError if formulae.empty?

    if dir = ARGV.value("destdir")
      unpack_dir = Pathname.new(dir)
      unpack_dir.mkpath
    else
      unpack_dir = Pathname.pwd
    end

    raise "Cannot write to #{unpack_dir}" unless unpack_dir.writable_real?

    formulae.each do |f|
      f.extend(UnpackPatch)
      stage_dir = unpack_dir.join("#{f.name}-#{f.version}")

      if stage_dir.exist?
        raise "Destination #{stage_dir} already exists!" unless ARGV.force?
        rm_rf stage_dir
      end

      oh1 "Unpacking #{f.name} to: #{stage_dir}"

      ENV['VERBOSE'] = '1' # show messages about tar
      f.brew { cp_r getwd, stage_dir }
      ENV['VERBOSE'] = nil

      if ARGV.flag? "--git"
        ohai "Setting up git repository"
        cd stage_dir
        system "git", "init", "-q"
        system "git", "add", "-A"
        system "git", "commit", "-q", "-m", "brew-unpack"
      end
    end
  end
end
