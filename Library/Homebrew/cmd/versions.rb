require 'formula'

module Homebrew extend self
  def versions
    raise "Please `brew install git` first" unless which "git"
    raise "Please `brew update' first" unless (HOMEBREW_REPOSITORY/".git").directory?

    raise FormulaUnspecifiedError if ARGV.named.empty?

    opoo <<-EOS.undent
      brew-versions is unsupported and may be removed soon.
      Please use the homebrew-versions tap instead:
        https://github.com/Homebrew/homebrew-versions
    EOS
    ARGV.formulae.all? do |f|
      if ARGV.include? '--compact'
        puts f.versions * " "
      else
        f.versions do |version, sha|
          print Tty.white.to_s
          print "#{version.to_s.ljust(8)} "
          print Tty.reset.to_s
          puts "git checkout #{sha} #{f.pretty_relative_path}"
        end
      end
    end
  end
end


class Formula
  def versions
    versions = []
    rev_list do |sha|
      version = version_for_sha sha
      unless versions.include? version or version.nil?
        yield version, sha if block_given?
        versions << version
      end
    end
    return versions
  end

  def bottle_version_map branch='HEAD'
    map = Hash.new { |h, k| h[k] = [] }
    rev_list(branch) do |rev|
      formula_for_sha(rev) do |f|
        bottle = f.stable.bottle_specification
        unless bottle.checksums.empty?
          map[f.pkg_version] << bottle.revision
        end
      end
    end
    map
  end

  def pretty_relative_path
    if Pathname.pwd == repository
      entry_name
    else
      repository/"#{entry_name}"
    end
  end

  private
    def repository
      @repository ||= begin
        if path.to_s =~ HOMEBREW_TAP_DIR_REGEX
          HOMEBREW_REPOSITORY/"Library/Taps/#$1-#$2"
        else
          HOMEBREW_REPOSITORY
        end
      end
    end

    def entry_name
      @entry_name ||= begin
        repository == HOMEBREW_REPOSITORY ? "Library/Formula/#{name}.rb" : "#{name}.rb"
      end
    end

    def rev_list branch='HEAD'
      repository.cd do
        IO.popen("git rev-list --abbrev-commit --remove-empty #{branch} -- #{entry_name}") do |io|
          yield io.readline.chomp until io.eof?
        end
      end
    end

    def text_from_sha sha
      repository.cd do
        `git cat-file blob #{sha}:#{entry_name}`
      end
    end

    IGNORED_EXCEPTIONS = [SyntaxError, TypeError, NameError,
                          ArgumentError, FormulaSpecificationError,
                          FormulaValidationError,]

    def version_for_sha sha
      formula_for_sha(sha) {|f| f.version }
    end

    def formula_for_sha sha, &block
      mktemp do
        path = Pathname.new(Pathname.pwd+"#{name}.rb")
        path.write text_from_sha(sha)

        # Unload the class so Formula#version returns the correct value
        begin
          old_const = Formulary.unload_formula name
          nostdout { yield Formula.factory(path.to_s) }
        rescue *IGNORED_EXCEPTIONS => e
          # We rescue these so that we can skip bad versions and
          # continue walking the history
          ohai "#{e} in #{name} at revision #{sha}", e.backtrace if ARGV.debug?
        rescue FormulaUnavailableError
          # Suppress this error
        ensure
          Formulary.restore_formula name, old_const
        end
      end
    end
end
