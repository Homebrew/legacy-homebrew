require "formula"

class FormulaVersions
  IGNORED_EXCEPTIONS = [
    ArgumentError, NameError, SyntaxError, TypeError,
    FormulaSpecificationError, FormulaValidationError,
  ]

  attr_reader :f

  def initialize(f)
    @f = f
  end

  def repository
    @repository ||= if f.tap?
      HOMEBREW_LIBRARY.join("Taps", f.tap)
    else
      HOMEBREW_REPOSITORY
    end
  end

  def entry_name
    @entry_name ||= f.path.relative_path_from(repository).to_s
  end

  def each
    versions = Set.new
    rev_list do |rev|
      version = version_at_revision(rev)
      next if version.nil?
      yield version, rev if versions.add?(version)
    end
  end

  def repository_path
    Pathname.pwd == repository ? entry_name : f.path
  end

  def rev_list(branch="HEAD")
    repository.cd do
      Utils.popen_read("git", "rev-list", "--abbrev-commit", "--remove-empty", branch, "--", entry_name) do |io|
        yield io.readline.chomp until io.eof?
      end
    end
  end

  def file_contents_at_revision(rev)
    repository.cd { `git cat-file blob #{rev}:#{entry_name}` }
  end

  def version_at_revision(rev)
    formula_at_revision(rev) { |f| f.version }
  end

  def formula_at_revision rev, &block
    FileUtils.mktemp(f.name) do
      path = Pathname.pwd.join("#{f.name}.rb")
      path.write file_contents_at_revision(rev)

      begin
        old_const = Formulary.unload_formula(f.name)
        nostdout { yield Formulary.factory(path.to_s) }
      rescue *IGNORED_EXCEPTIONS => e
        # We rescue these so that we can skip bad versions and
        # continue walking the history
        ohai "#{e} in #{f.name} at revision #{rev}", e.backtrace if ARGV.debug?
      rescue FormulaUnavailableError
        # Suppress this error
      ensure
        Formulary.restore_formula(f.name, old_const)
      end
    end
  end

  def bottle_version_map(branch="HEAD")
    map = Hash.new { |h, k| h[k] = [] }
    rev_list(branch) do |rev|
      formula_at_revision(rev) do |f|
        bottle = f.stable.bottle_specification
        unless bottle.checksums.empty?
          map[f.pkg_version] << bottle.revision
        end
      end
    end
    map
  end
end
