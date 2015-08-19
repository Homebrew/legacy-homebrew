require "formula"

class FormulaVersions
  IGNORED_EXCEPTIONS = [
    ArgumentError, NameError, SyntaxError, TypeError,
    FormulaSpecificationError, FormulaValidationError,
    ErrorDuringExecution, LoadError
  ]

  attr_reader :name, :repository, :entry_name

  def initialize(formula)
    @name = formula.name
    @repository = formula.tap? ? HOMEBREW_LIBRARY.join("Taps", formula.tap) : HOMEBREW_REPOSITORY
    @entry_name = formula.path.relative_path_from(repository).to_s
  end

  def rev_list(branch)
    repository.cd do
      Utils.popen_read("git", "rev-list", "--abbrev-commit", "--remove-empty", branch, "--", entry_name) do |io|
        yield io.readline.chomp until io.eof?
      end
    end
  end

  def file_contents_at_revision(rev)
    repository.cd { Utils.popen_read("git", "cat-file", "blob", "#{rev}:#{entry_name}") }
  end

  def formula_at_revision(rev)
    FileUtils.mktemp(name) do
      path = Pathname.pwd.join("#{name}.rb")
      path.write file_contents_at_revision(rev)

      begin
        nostdout { yield Formulary.factory(path.to_s) }
      rescue *IGNORED_EXCEPTIONS => e
        # We rescue these so that we can skip bad versions and
        # continue walking the history
        ohai "#{e} in #{name} at revision #{rev}", e.backtrace if ARGV.debug?
      rescue FormulaUnavailableError
        # Suppress this error
      end
    end
  end

  def bottle_version_map(branch)
    map = Hash.new { |h, k| h[k] = [] }
    rev_list(branch) do |rev|
      formula_at_revision(rev) do |f|
        bottle = f.bottle_specification
        unless bottle.checksums.empty?
          map[f.pkg_version] << bottle.revision
        end
      end
    end
    map
  end
end
